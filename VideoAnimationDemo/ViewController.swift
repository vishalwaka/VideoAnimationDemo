//
//  ViewController.swift
//  VideoAnimationDemo
//
//  Created by user136229 on 2/16/18.
//  Copyright © 2018 Vishal Madheshia. All rights reserved.
//

import UIKit
import AVKit


class ViewController: UIViewController {

    let controller = AVPlayerViewController()
    
    @IBOutlet weak var videoShowingView: UIView!
    @IBOutlet weak var viewWithText: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addVideoView()
        playVideo()
        setRandomViewHeight()
        animateVideo()
    }
    
    private func addVideoView() {
        configureVideoViewForFullScreen()
        self.view.addSubview(controller.view)
    }
    
    private func playVideo() {
        controller.player?.play()
    }
    
    private func setRandomViewHeight() {
        viewHeightConstraint.constant = CGFloat(arc4random_uniform(200)) + CGFloat(400)
    }
    
    private func configureVideoViewForFullScreen() {
        
        guard let url = URL(string: urlVideo) else { return }
        
        let player = AVPlayer(url: url)
        
        controller.player = player
        controller.showsPlaybackControls = false
        self.addChildViewController(controller)
        let screenSize = UIScreen.main.bounds.size
        let videoFrame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        controller.view.frame = videoFrame
        
    }

    fileprivate func setCircularViewVideoConstraint() {
       
        controller.view.frame = CGRect(x: view.frame.midX - videoViewHeight / 2, y: view.frame.midY - viewHeightConstraint.constant / 2 - videoViewHeight / 2, width: videoViewHeight, height: videoViewHeight)
        controller.view.layer.cornerRadius = controller.view.frame.height / 2
        controller.view.clipsToBounds = true
        controller.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
    }
    
    private func animateVideo() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 0.01, delay: 0.1, options: [.curveEaseOut], animations: {
                [weak self] in
                
                guard let weakSelf = self else { return }
                weakSelf.setCircularViewVideoConstraint()
                weakSelf.view.bringSubview(toFront: (weakSelf.viewWithText))
                weakSelf.view.bringSubview(toFront: weakSelf.controller.view)
                }, completion: { success in
                    guard success else { return };
                    self.showFullVideo()
            })
        }
    }
    
    private func showFullVideo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: { [weak self] in
            guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseOut], animations: {
                weakSelf.controller.view.frame = weakSelf.view.frame
                weakSelf.controller.view.layer.cornerRadius = 0
                weakSelf.view.bringSubview(toFront: (weakSelf.controller.view))
            }, completion: nil)
        })
    }
}
