//
//  AudioViewController.swift
//  
//
//  Created by mac on 01/08/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import AVFoundation
import AVKit
class AudioViewController: UIViewController {
    //MARK: Variables
    var ref = Storage.storage().reference()
   
    
    //MARK: Outlets
    @IBOutlet weak var lblSuccessful: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var outletSlider: UISlider!
    @IBOutlet weak var outletUploadVideo: UIButton!
    
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    //MARK: Button Actions
  
    @IBAction func btnActionGetVideo(_ sender: UIButton) {
        // Create a reference to the file you want to download
        let islandRef = ref.child("videos/bird.mp4")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.downloadURL(completion: { url, error in
            if let error = error {
                //Something Fishy Happens
            }else{
                let player = AVPlayer(url: url!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            }
       })
    }
                              
    
    @IBAction func uploadVideo(_ sender: UIButton) {
        let videoData = NSURL(fileURLWithPath: Bundle.main.path(forResource: "VideoFile", ofType: "mp4")!)
        do{
        let file = try Data(contentsOf: videoData as URL)
        // Data in memory
        let data = file
        // Create a reference to the file you want to upload
        let riversRef = ref.child("videos/bird.mp4")
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
            print(size)
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
              print(downloadURL)
          }
        }
        }catch{
            print(error)
        }
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
    }
    

    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnActionPlayVideo(_ sender: UIButton) {
        let file = NSURL(fileURLWithPath: Bundle.main.path(forResource: "VideoFile", ofType: "mp4")!)
        let videoURL = file
        let player = AVPlayer(url: videoURL as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
//            let videoURL = file
//            let player = AVPlayer(url: videoURL as URL)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.view.bounds
//            self.view.layer.addSublayer(playerLayer)
//            player.play()
  }
//https://cdn.pixabay.com/vimeo/641767478/Trees%20-%2093826.mp4?width=1280&expiry=1659352049&hash=f0046ccaac668245c2c91bde862fd7c3f2ee4c99

    
    @IBAction func btnActionGetVideoFromLink(_ sender: UIButton) {
     let url = NSURL(string: "https://static.videezy.com/system/resources/previews/000/043/147/original/200125_07_Plexus-virus-red.mp4")
                    let videoURL = url
        let player = AVPlayer(url: videoURL! as URL)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.view.bounds
                    self.view.layer.addSublayer(playerLayer)
                    player.play()
//        
//        do{
//            // File located on disk
//            let localFile = url
//
//            // Create a reference to the file you want to upload
//            let riversRef = ref.child("new/influenza.mp4")
//
//            // Upload the file to the path "images/rivers.jpg"
//            let uploadTask = riversRef.putFile(from: localFile as! URL, metadata: nil) { metadata, error in
//              guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//              }
//              // Metadata contains file metadata such as size, content-type.
//              let size = metadata.size
//              // You can also access to download URL after upload.
//              riversRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                  // Uh-oh, an error occurred!
//                  return
//                }
//              }
//            }
//        }catch{
//            print(error)
//        }
    }
}
    //MARK: Extensions
