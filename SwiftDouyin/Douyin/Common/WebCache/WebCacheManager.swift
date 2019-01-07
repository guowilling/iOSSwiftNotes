
import Foundation

/// 缓存查询完成后的回调闭包, data 返回类型包括 NSString 缓存文件路径、NSData 缓存数据
typealias WebCacheQueryCompletedClosure = (_ data: Any?, _ hasCache: Bool) -> Void

/// 缓存清除完成后的回调闭包
typealias WebCacheClearCompletedClosure = (_ cacheSize: String) -> Void

class WebCacheManager: NSObject {
    
    var memCache: NSCache<NSString, AnyObject>?
    
    var diskCacheDirectoryURL: URL?
    
    var ioQueue: DispatchQueue?
    
    private static let instance = { () -> WebCacheManager in
        return WebCacheManager.init()
    }()
    
    private override init() {
        super.init()
        
        self.memCache = NSCache()
        self.memCache?.name = "webCache"
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let diskCachePath = documentDirectory! + "/webCache"
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: diskCachePath, isDirectory: &isDirectory) || !isDirectory.boolValue {
            do {
                try FileManager.default.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Create disk cache directory error: " + error.localizedDescription)
            }
        }
        diskCacheDirectoryURL = URL(fileURLWithPath: diskCachePath)
        
        ioQueue = DispatchQueue(label: "com.webcache.queue")
    }
    
    class func shared() -> WebCacheManager {
        return instance
    }
    
    /// 根据 key 从内存和本地磁盘中查询缓存数据
    func queryDataFromMemory(key:String, completed: WebCacheQueryCompletedClosure) -> Operation{
        return queryDataFromMemory(key: key, completed: completed, exten: nil)
    }
    
    /// 根据 key 和指定文件类型从内存和本地磁盘中查询缓存数据
    func queryDataFromMemory(key:String, completed: WebCacheQueryCompletedClosure, exten:String?) -> Operation {
        let operation = Operation()
        ioQueue?.sync {
            if (operation.isCancelled) {
                return
            }
            if let data = self.dataFromMemoryCache(key: key) {
                completed(data, true)
            } else if let data = self.dataFromDiskCache(key: key, exten: exten) {
                storeDataToMemoryCache(data: data, key: key)
                completed(data, true)
            } else {
                completed(nil, false)
            }
        }
        return operation
    }
    
    func queryURLFromDiskMemory(key: String, completed: WebCacheQueryCompletedClosure) -> Operation {
        return queryURLFromDiskMemory(key: key, completed: completed, exten: nil)
    }
    
    func queryURLFromDiskMemory(key: String, completed: WebCacheQueryCompletedClosure, exten: String?) -> Operation {
        let operation = Operation()
        ioQueue?.sync {
            if (operation.isCancelled) {
                return
            }
            let path = diskCachePathForKey(key: key, exten: exten) ?? ""
            if FileManager.default.fileExists(atPath: path) {
                completed(path, true)
            } else {
                completed(path, false)
            }
        }
        return operation
    }
    
    func dataFromMemoryCache(key: String) ->Data? {
        return memCache?.object(forKey: key as NSString) as? Data
    }
    
    func dataFromDiskCache(key: String, exten: String?) -> Data? {
        if let cachePathForKey = diskCachePathForKey(key: key, exten: exten) {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: cachePathForKey))
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    /// 存储数据到内存和磁盘
    func storeDataToCache(data: Data?, key: String) {
        ioQueue?.async {
            self.storeDataToMemoryCache(data: data, key: key)
            self.storeDataToDiskCache(data: data, key: key)
        }
    }
    
    /// 存储数据到内存
    func storeDataToMemoryCache(data: Data?, key: String) {
        memCache?.setObject(data as AnyObject, forKey: key as NSString)
    }
    
    /// 存储数据到磁盘
    func storeDataToDiskCache(data: Data?, key: String) {
        self.storeDataToDiskCache(data: data, key: key, exten: nil)
    }
    
    /// 存储数据到磁盘
    func storeDataToDiskCache(data: Data?, key: String, exten: String?)  {
        if let diskPath = diskCachePathForKey(key: key, exten: exten) {
            FileManager.default.createFile(atPath: diskPath, contents: data, attributes: nil)
        }
    }
    
    func diskCachePathForKey(key: String) -> String? {
        return diskCachePathForKey(key: key, exten: nil)
    }
    
    func diskCachePathForKey(key: String, exten: String?) -> String? {
        let fileName = md5(key: key)
        let cachePathForKey = diskCacheDirectoryURL?.appendingPathComponent(fileName).path
        guard let exten = exten else {
            return cachePathForKey
        }
        return cachePathForKey! + "." + exten
    }
    
    /// 清除缓存, 内存和磁盘
    func clearCache(cacheClearCompletedBlock:@escaping WebCacheClearCompletedClosure) {
        ioQueue?.async {
            self.clearMemoryCache()
            let cacheSize = self.clearDiskCache()
            DispatchQueue.main.async {
                cacheClearCompletedBlock(cacheSize)
            }
        }
    }
    
    /// 清除内存缓存
    func clearMemoryCache() {
        memCache?.removeAllObjects()
    }
    
    /// 清除磁盘缓存
    func clearDiskCache() -> String {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: (diskCacheDirectoryURL?.path)!)
            var cacheSize: Float = 0
            for fileName in contents {
                let filePath = diskCacheDirectoryURL!.path + "/" + fileName
                let fileDict = try FileManager.default.attributesOfItem(atPath: filePath)
                cacheSize += fileDict[FileAttributeKey.size] as! Float
                try FileManager.default.removeItem(atPath: filePath)
            }
            return String.format(decimal: cacheSize / 1024.0 / 1024.0) ?? "0"
        } catch {
            print("clearDiskCache error: " + error.localizedDescription)
        }
        return "0"
    }
}

extension WebCacheManager {
    func md5(key: String) -> String {
        let cString = key.cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cString, CC_LONG(strlen(cString!)), buffer)
        var md5String = ""
        for idx in 0...15 {
            let str = String(format: "%02x", buffer[idx])
            md5String.append(str)
        }
        free(buffer)
        return md5String
    }
}
