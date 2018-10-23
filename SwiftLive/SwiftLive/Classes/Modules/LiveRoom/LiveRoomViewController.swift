//
//  LiveRoomViewController.swift
//  SwiftLive
//
//  Created by 郭伟林 on 2017/9/21.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit
import IJKMediaFramework

class LiveRoomViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var roomNumLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    
    fileprivate lazy var liveRoomVM: LiveRoomViewModel = LiveRoomViewModel()
    
    fileprivate var player: IJKFFMoviePlayerController?
    
    var anchorModel: AnchorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadRoomInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        player?.shutdown()
    }
}

extension LiveRoomViewController {
    
    fileprivate func setupUI() {
        setupBlurView()
        setupRoomInfo()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    func setupRoomInfo() {
        bgImageView.setImage(anchorModel?.pic74)
        iconImageView.setImage(anchorModel?.pic51)
        nickNameLabel.text = anchorModel?.name
        roomNumLabel.text = "房间号: \(anchorModel?.roomid ?? 0)"
        onlineLabel.text = "\(anchorModel?.focus ?? 0)"
    }
}

extension LiveRoomViewController {
    
    fileprivate func loadRoomInfo() {
        if let roomid = anchorModel?.roomid, let uid = anchorModel?.uid {
            print("roomid = \(roomid), uid = \(uid)")
            liveRoomVM.loadLiveURL(roomid, uid) {
                self.playLive()
            }
        }
    }
    
    func playLive() {
        let liveURL = URL(string: liveRoomVM.liveURLString)
        player = IJKFFMoviePlayerController(contentURL: liveURL, with: nil)
        if anchorModel?.push == 1 {
            player?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH * 3 / 4)
            player?.view.center.y = SCREEN_HEIGHT * 0.5
        } else {
            player?.view.frame = view.bounds
        }
        bgImageView.insertSubview(player!.view, at: 1)
        
        DispatchQueue.global().async {
            self.player?.prepareToPlay()
            self.player?.play()
        }
        
        IJKFFMoviePlayerController.setLogReport(false)
    }
    
}

extension LiveRoomViewController {
    
    @IBAction func closeBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func focusBtnClick(btn : UIButton) {
        btn.isSelected = !btn.isSelected
//        if btn.isSelected {
//            anchor?.inserIntoDB()
//        } else {
//            anchor?.deleteFromDB()
//        }
    }
}

extension LiveRoomViewController {
    
    @IBAction func zanAnimationAction(sender: UIButton) {

    }
    
    @IBAction func moreAction() {

    }
    
    @IBAction func giftAction() {

    }
    
    @IBAction func shareAction() {

    }
    
    @IBAction func chatAction() {

    }
}
