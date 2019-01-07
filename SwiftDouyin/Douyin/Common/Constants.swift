
import Foundation
import AdSupport

// MARK: - URLs

let Host: String = "http://116.62.9.17:8080"

/// 创建访客用户接口
let CREATE_VISITOR_BY_UDID: String = "/douyin/visitor/create"

/// 根据用户id获取用户信息
let FIND_USER_BY_UID: String = "/douyin/user"

/// 获取用户发布的短视频列表数据
let LIST_AWEME_POST: String = "/douyin/aweme/post"
/// 获取用户喜欢的短视频列表数据
let LIST_AWEME_FAVORITE: String = "/douyin/aweme/favorite"

/// 发送文本类型群聊消息
let POST_GROUP_CHAT_TEXT: String = "/douyin/groupchat/text"
/// 发送单张图片类型群聊消息
let POST_GROUP_CHAT_IMAGE: String = "/douyin/groupchat/image"
/// 发送多张图片类型群聊消息
let POST_GROUP_CHAT_IMAGES_URL:String = "/douyin/groupchat/images"
/// 获取群聊列表数据
let LIST_GROUP_CHAT:String = "/douyin/groupchat/list"
/// 根据id获取指定图片
let FIND_GROUP_CHAT_BY_IMAGE_ID_URL:String = "/douyin/groupchat/image"
/// 根据id删除指定群聊消息
let DELETE_GROUP_CHAT_BY_ID: String = "/douyin/groupchat/delete"

/// 获取评论列表
let LIST_COMMENT: String = "/douyin/comment/list"
/// 根据视频id发送评论
let POST_COMMENT: String = "/douyin/comment/post"
/// 根据id删除评论
let DELETE_COMMENT_BY_ID: String = "/douyin/comment/delete"

//let UDID: String = (UIDevice.current.identifierForVendor?.uuidString)!
let UDID: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
let UDID_MD5:String = UDID.md5()

// MARK: - Layout

let ScreenFrame: CGRect = UIScreen.main.bounds
let ScreenWidth = ScreenFrame.size.width
let ScreenHeight = ScreenFrame.size.height
let StatusBarHeight = UIApplication.shared.statusBarFrame.height
let SafeAreaTopHeight: CGFloat = (ScreenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let SafeAreaBottomHeight: CGFloat = (ScreenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 30 : 0)

// MARK: - Color

func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) ->UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

let ColorWhiteAlpha10: UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.1)
let ColorWhiteAlpha20: UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.2)
let ColorWhiteAlpha40: UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.4)
let ColorWhiteAlpha60: UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.6)
let ColorWhiteAlpha80: UIColor = RGBA(r:255.0, g:255.0, b:255.0, a:0.8)

let ColorBlackAlpha10: UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.1)
let ColorBlackAlpha20: UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.2)
let ColorBlackAlpha40: UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.4)
let ColorBlackAlpha60: UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.6)
let ColorBlackAlpha80: UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.8)
let ColorBlackAlpha90: UIColor = RGBA(r:0.0, g:0.0, b:0.0, a:0.9)

let ColorThemeGrayLight: UIColor = RGBA(r:104.0, g:106.0, b:120.0, a:1.0)
let ColorThemeGray: UIColor = RGBA(r:92.0, g:93.0, b:102.0, a:1.0)
let ColorThemeGrayDark: UIColor = RGBA(r:20.0, g:21.0, b:30.0, a:1.0)
let ColorThemeYellow: UIColor = RGBA(r:250.0, g:206.0, b:21.0, a:1.0)
let ColorThemeYellowDark: UIColor = RGBA(r:235.0, g:181.0, b:37.0, a:1.0)
let ColorThemeBackground: UIColor = RGBA(r:14.0, g:15.0, b:26.0, a:1.0)
let ColorThemeRed: UIColor = RGBA(r:241.0, g:47.0, b:84.0, a:1.0)

let ColorRoseRed: UIColor = RGBA(r:220.0, g:46.0, b:123.0, a:1.0)
let ColorClear: UIColor = UIColor.clear
let ColorBlack: UIColor = UIColor.black
let ColorWhite: UIColor = UIColor.white
let ColorGray: UIColor =  UIColor.gray
let ColorBlue: UIColor = RGBA(r:40.0, g:120.0, b:255.0, a:1.0)
let ColorGrayLight: UIColor = RGBA(r:40.0, g:40.0, b:40.0, a:1.0)
let ColorGrayDark: UIColor = RGBA(r:25.0, g:25.0, b:35.0, a:1.0)
let ColorSmoke: UIColor = RGBA(r:230.0, g:230.0, b:230.0, a:1.0)

// MARK: - Font

let SuperSmallFont: UIFont = UIFont.systemFont(ofSize: 10.0)
let SuperSmallBoldFont: UIFont = UIFont.boldSystemFont(ofSize: 10.0)

let SmallFont: UIFont = UIFont.systemFont(ofSize: 12.0)
let SmallBoldFont: UIFont = UIFont.boldSystemFont(ofSize: 12.0)

let MediumFont: UIFont = UIFont.systemFont(ofSize: 14.0)
let MediumBoldFont: UIFont = UIFont.boldSystemFont(ofSize: 14.0)

let BigFont:UIFont = UIFont.systemFont(ofSize: 16.0)
let BigBoldFont:UIFont = UIFont.boldSystemFont(ofSize: 16.0)

let LargeFont:UIFont = UIFont.systemFont(ofSize: 18.0)
let LargeBoldFont:UIFont = UIFont.boldSystemFont(ofSize: 18.0)

let SuperBigFont:UIFont = UIFont.systemFont(ofSize: 26.0)
let SuperBigBoldFont:UIFont = UIFont.boldSystemFont(ofSize: 26.0)
