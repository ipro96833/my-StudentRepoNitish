//
//  RecordedVideoViewController.swift
//  Pods
//
//  Created by mac on 01/08/22.
//

import UIKit
import AVFoundation
import AVKit
class RecordedVideoViewController: UIViewController {
    var videoURL:URL?
    let avPlayer = AVPlayer()
      var avPlayerLayer: AVPlayerLayer!

    
    @IBOutlet weak var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
              avPlayerLayer.frame = view.bounds
              avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
              videoView.layer.insertSublayer(avPlayerLayer, at: 0)
              view.layoutIfNeeded()
        let playerItem = AVPlayerItem(url: videoURL! as URL)
              avPlayer.replaceCurrentItem(with: playerItem)
              avPlayer.play()
        }
       
    }
