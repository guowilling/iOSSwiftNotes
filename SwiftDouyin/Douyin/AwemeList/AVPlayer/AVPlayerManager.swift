
import Foundation
import AVFoundation

class AVPlayerManager: NSObject {
    
    var playerArray = [AVPlayer]()
    
    private static let instance = { () -> AVPlayerManager in
        return AVPlayerManager()
    }()
    
    private override init() {
        super.init()
        print("init AVPlayerManager instance" )
    }
    
    class func shared() -> AVPlayerManager {
        return instance
    }
    
    static func setAudioMode() {
        do {
            if #available(iOS 10.0, *) {
                try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            } else {
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVPlayerManager setAudioMode error: \(error.localizedDescription)")
        }
    }
    
    func play(player: AVPlayer) {
        for object in playerArray {
            object.pause()
        }
        if !playerArray.contains(player) {
            playerArray.append(player)
        }
        player.play()
    }
    
    func pause(player: AVPlayer) {
        if playerArray.contains(player) {
            player.pause()
        }
    }
    
    func replay(player: AVPlayer) {
        for object in playerArray {
            object.pause()
        }
        if playerArray.contains(player) {
            player.seek(to: CMTime.zero)
            play(player: player)
        } else {
            playerArray.append(player)
            play(player: player)
        }
    }
    
    func pauseAll() {
        for object in playerArray {
            object.pause()
        }
    }
}
