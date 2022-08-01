//
//  ViewController.swift
//  AudioVideoApp
//
//  Created by mac on 28/07/22.
//

import UIKit
import AVFoundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
   
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    if response {
                        //access granted
                    } else {

                    }
                }
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
}
class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    //MARK: Variables
    var audioPlayer = AVAudioPlayer()
    var playing: Bool = false
    var updaterRunning : Bool = false
    var updater : CADisplayLink? = nil
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var imageData = UIImage()
    var ref = Storage.storage().reference()
    var nextImageIndex: Int {
        UserDefaults.standard.integer(forKey: "NextImageIndex") + 1  //+1 if you want to start with 1
    }
    var storage = Storage.storage()
    var saveAudioToFirebasePath = ""
    
    //MARK: Outlets
    
    @IBOutlet weak var lblMusic: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var btnOutletRecord: UIButton!
    @IBOutlet weak var btnOutletPrevious: UIButton!
    @IBOutlet weak var btnOutletPlay: UIButton!
    @IBOutlet weak var btnOutletStop: UIButton!
    @IBOutlet weak var lblSuccessfullyRecorded: UILabel!
    
    @IBOutlet weak var btnOutletAddImage: UIButton!
    
    
    //MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOutletPlay.isSelected = !btnOutletPlay.isSelected
     //   let file = NSURL(fileURLWithPath: Bundle.main.path(forResource: "file1", ofType: "mp3")!)
//        do{
//            try audioPlayer = AVAudioPlayer(contentsOf: file as URL, fileTypeHint:  nil)
//            audioPlayer.prepareToPlay()
//        }catch let err as NSError{
//            print(err.debugDescription)
//        }
               
               audioPlayer.delegate = self

               sliderOutlet.isContinuous = false
        check_record_permission()
     //   loadSavedImage()
        let tapGesture = UITapGestureRecognizer()
        imgViewIcon.isUserInteractionEnabled = true
        imgViewIcon.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(ViewController.openGallery(tapGesture:)))
       
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
          if playing == true {
              audioPlayer.stop()
          }
        updater?.invalidate()
          updaterRunning = false
          super.viewWillDisappear(animated)
      }
    
    //MARK: Button Actions
    
    @IBAction func btnActionBack(_ sender: UIButton) {
    }
    
    @IBAction func btnActionRecord(_ sender: UIButton) {
        if(isRecording)
            {
                finishAudioRecording(success: true)
            //    record_btn_ref.setTitle("Record", for: .normal)
                btnOutletPrevious.isEnabled = true
                isRecording = false
            }
            else
            {
                setup_recorder()
                audioRecorder.record()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
             //   record_btn_ref.setTitle("Stop", for: .normal)
                btnOutletPrevious.isEnabled = false
                isRecording = true
            }
        
    }
    
    @IBAction func btnActionPrevious(_ sender: UIButton) {
        if(playing)
           {
            updateProgress()
            audioPlayer.stop()
               btnOutletRecord.isEnabled = true
          //     play_btn_ref.setTitle("Play", for: .normal)
               playing = false
           }
           else
           {
               
               if FileManager.default.fileExists(atPath: getFileUrl().path)
               {
                   updater?.frameInterval = 1
                   updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
                   updaterRunning = true
                   btnOutletRecord.isEnabled = false
             //      play_btn_ref.setTitle("pause", for: .normal)
                   prepare_play()
                   audioPlayer.play()
                   playing = true
                   updateProgress()
               }
               else
               {
                   display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
               }
           }
    }
    @available (iOS 9.3, *)
    @IBAction func btnActionPlay(_ sender: UIButton) {
        if (playing == false) {
            updater = CADisplayLink(target: self, selector: #selector(updateProgress))
            
            updater?.frameInterval = 1
            updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
                   updaterRunning = true
                   audioPlayer.play()
            let pause = UIImage(named: "pause")
            btnOutletPlay.setImage(pause!, for: .normal)
            btnOutletPlay.isSelected = true // pause image is assigned to "selected"
                   playing = true
                   updateProgress()
               } else {
                   updateProgress()  // update track time
                   audioPlayer.pause()  // then pause
                   let playImage = UIImage(named: "play")
                   btnOutletPlay.setImage(playImage!, for: .normal)
                   btnOutletPlay.isSelected = false  // show play image (unselected button)
                   playing = false // note track has stopped playing
               }
    }
    
    @IBAction func btnActionStop(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AudioViewController")as! AudioViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
        var wasPlaying : Bool = false
               if playing == true {
                   audioPlayer.pause()
                   wasPlaying = true
               }
               audioPlayer.currentTime = TimeInterval(round(sliderOutlet.value))
               updateProgress()
               // starts playing track again it it had been playing
               if (wasPlaying == true) {
                   audioPlayer.play()
                   wasPlaying = false
               }
        
    }
    
    //https://cdn.pixabay.com/photo/2018/08/14/13/23/ocean-3605547_960_720.jpg
    //https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=898&q=80
    @IBAction func btnActionAddImage(_ sender: UIButton) {
        
        print("Button Click")
        let strUrl = "https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=898&q=80"
        let dataurl = URL(string: strUrl)
        var request = URLRequest(url: dataurl!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: completion(data:response:error:))
        task.resume()
    }
    
    @IBAction func btnActionSaveDataToFirebase(_ sender: UIButton) {
        if imgViewIcon.image != nil{
            
            uploadImage() { url in
                guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                      return
                    }
                print(downloadURL)
            }
        }else {

              let alertController = UIAlertController(title: "Oops!", message: "Field left blank", preferredStyle: .alert)

              let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
              alertController.addAction(defaultAction)

              self.present(alertController, animated: true, completion: nil)

              }
          
    }
    
    @IBAction func btnActionGallery(_ sender: UIButton) {
        let storageRef = Storage.storage().reference()
        // Create a reference to the file you want to download
        let islandRef = storageRef.child("images/myImage.png")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            // Uh-oh, an error occurred!
              print("error Occurred")
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
              self.imgViewIcon.image = image!
              
          }
        }
    }
    
    
    @IBAction func btnActionSaveAudio(_ sender: UIButton) {
        
        let str:String? = self.saveAudioToFirebasePath
    //    let file = NSURL(fileURLWithPath: Bundle.main.path(forResource: "file1", ofType: "mp3")!)
        
        if str != nil{
            guard let localFile = URL(string: str ?? "nil") else{ return }

            // Create a reference to the file you want to upload
            let riversRef = ref.child("audio/recording.aac")

            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                  print(error?.localizedDescription)
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
              }
            }

        }
    }
    
    
    @IBAction func btnActionGetAudio(_ sender: UIButton) {     
        let starsRef = ref.child("audio/recording.aac")

        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
          if let error = error {
            // Handle any errors
          } else {
            // Get the download URL for 'images/stars.jpg'
            print(url)
              do{
                  let session = AVAudioSession.sharedInstance()
                  try session.setCategory(AVAudioSession.Category.playback)
                  let soundData = try Data(contentsOf: url!)
                  audioPlayer = try AVAudioPlayer(data: soundData)
                  
                  audioPlayer.prepareToPlay()
                  
                  updater = CADisplayLink(target: self, selector: #selector(updateProgress))
                  
                  updater?.frameInterval = 1
                  updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
                         updaterRunning = true
                         audioPlayer.play()
                  let pause = UIImage(named: "pause")
                  btnOutletPlay.setImage(pause!, for: .normal)
                  btnOutletPlay.isSelected = true // pause image is assigned to "selected"
                         playing = true
                         updateProgress()
                  
              }catch let err as NSError{
                  print(err.debugDescription)
              }
          }
        }
    }
    
    //MARK: Functions
    func uploadImage(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("images/myImage.png")
        if let uploadData = self.imgViewIcon.image!.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in

                        print(url?.absoluteString as Any)
                                      completion(url?.absoluteString)
                                  })
                }
           }
        }
    }
    func saveImageToDocumentDirectory(image: UIImage ) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileName = "Image-\(nextImageIndex).png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let fileAlreadyExists = FileManager.default.fileExists(atPath: fileURL.path)
        if let data = image.jpegData(compressionQuality: 1.0), !fileAlreadyExists {
            do {
                try data.write(to: fileURL)
                incrementImageIndex()
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func saveselectedImage(img:UIImage){

        //find path of document directory of my app
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
        //give a name to a file to save the image
        let imagePath = pathArray[0] + "/MyPic\(nextImageIndex).png"
        // get binary data of selected image
        let profileImage = img.pngData()!
        
        //save binary data of image at imagepath
        let fm:FileManager = FileManager.default
        fm.createFile(atPath: imagePath, contents: profileImage, attributes: nil)
        print("File Saved")

    }
    func loadSavedImage(){
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
        
        //give a name to a file to save the image
        let imagePath = pathArray[0] + "/MyPic.png"
        
        //get data of picture at imagepath
        let fm = FileManager.default
        guard let imageData = fm.contents(atPath: imagePath) else { return  }
        //prepare image with image data
        
        let DisplayImage = UIImage(data: imageData)
        imgViewIcon.image = DisplayImage
    }
    @objc func openGallery(tapGesture: UITapGestureRecognizer){
        print("Hello")
        ImagePickerManager().pickImage(self){ [self] image in
            self.imgViewIcon.image = image
            saveselectedImage(img: image)
           }
    }
    func completion(data:Data?, response:URLResponse?, error:Error?) -> Void{
        if data != nil && error == nil{
            
            guard let imgDAta = data else{return}
                print(imgDAta)
            DispatchQueue.global(qos: .background).async {
               
                DispatchQueue.main.async {
                    //your main thread
                    self.imgViewIcon.image = UIImage(data: imgDAta)
                    self.imageData = self.imgViewIcon.image!
                    print(self.imageData)
                    
                }
            }
        }
    }
   @objc func updateProgress() {
            let total = Float(audioPlayer.duration/60)
            let current_time = Float(audioPlayer.currentTime/60)
            sliderOutlet.minimumValue = 0.0
            sliderOutlet.maximumValue = Float(audioPlayer.duration)
            sliderOutlet.setValue(Float(audioPlayer.currentTime), animated: true)
            lblSuccessfullyRecorded.text = ""
            lblSuccessfullyRecorded.text = NSString(format: "%.2f/%.2f", current_time, total) as String
        }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           if flag {
               btnOutletPlay.isSelected = false
               playing = false
               audioPlayer.currentTime = 0.0
               updateProgress()
               updater?.invalidate()

           }
        btnOutletRecord.isEnabled = true
       }
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL
    {
        let filename = "myRecording.aac"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        print(filePath)
        self.saveAudioToFirebasePath = filePath.absoluteString
        
        
    return filePath
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            lblSuccessfullyRecorded.text = ""
            lblSuccessfullyRecorded.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        btnOutletPrevious.isEnabled = true
    }
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
        _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    func incrementImageIndex() {
        UserDefaults.standard.setValue(nextImageIndex, forKey: "NextImageIndex")
    }

}
    //MARK: Extensions
