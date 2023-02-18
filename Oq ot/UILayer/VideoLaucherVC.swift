//
//  VideoLaucherVC.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 23/09/22.
//

import UIKit
import AVFoundation

class VideoLaucherVC: BaseViewController {

    func setupAVPlayer() {

        let videoURL = Bundle.main.url(forResource: "Video", withExtension: "mp4") // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height) // Set bounds of avPlayerLayer
        self.view.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayer.play() // Play video

        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in

            if time == avAssets.duration {
                let vc = UD.didChooseLanguage == false ? LanguageController() :  MainTabbarController(isRegistered: UD.token != nil)
                AppDelegate.shared?.setRoot(viewController: vc)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAVPlayer()  // Call method to setup AVPlayer & AVPlayerLayer to play video
    }
}
