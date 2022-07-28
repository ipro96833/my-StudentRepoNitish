//
//  StudentRegistrationViewController.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit
import CoreData
import UserNotifications
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


class StudentRegistrationViewController: UIViewController , UNUserNotificationCenterDelegate,UITextFieldDelegate{
    //MARK: Variables
    var imageForStudent = Data()
    let notificationCenter = UNUserNotificationCenter.current()
    //MARK: Outlets
    
    
    @IBOutlet weak var imgViewStudent: UIImageView!
    @IBOutlet weak var btnOutletCamera: UIButton!
    @IBOutlet weak var txtFieldStudentId: UITextField!
    @IBOutlet weak var txtFieldStudentName: UITextField!
    @IBOutlet weak var txtFieldStandard: UITextField!
    @IBOutlet weak var txtFieldClassTeacher: UITextField!
    @IBOutlet weak var btnOutletSaveDetails: UIButton!
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            
        }
        txtFieldStandard.delegate = self
        txtFieldStudentId.delegate = self
        txtFieldStudentName.delegate = self
        txtFieldClassTeacher.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set("", forKey: "Data")
    }
    //MARK: TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFieldStandard.resignFirstResponder()
        txtFieldStudentId.resignFirstResponder()
        txtFieldStudentName.resignFirstResponder()
        txtFieldClassTeacher.resignFirstResponder()
        return true
    }
    //MARK: Button Actions
    
    @IBAction func btnActionSaveDetails(_ sender: Any) {
       
        let dict = ["name":txtFieldStudentName.text!,"standard":txtFieldStandard.text!,"classTeacher":txtFieldClassTeacher.text!,"id":txtFieldStudentId.text!,"totalMarks":""]
        let imageData = imageForStudent
        CoreDataHelper.sharedInstance.save(object: dict,img: imageData)
        print("Data Saved")
        
        //MARK: Content
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Category Identifier"
        content.title = "Student Saved"
        content.body = "This is the example of Local Notification"
        content.badge = 1
        content.sound = UNNotificationSound.default
        content.userInfo = ["name": "Yogesh"]
        //Mark : Trigger Time
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let identifier = "Main Identifier"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        //Notification Add Request
        notificationCenter.add(request) { error in
            print(error?.localizedDescription as Any)
        }
        //Content-Image
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
  //      let img = imageForStudent
        let name = txtFieldStudentName.text!
        let imagePath = pathArray[0] + "/\(name).png"
        let url = Bundle.main.url(forResource: "stu1", withExtension: "png")
//        do
//        {
//            let attachment = try UNNotificationAttachment(identifier: "Image", url: url!, options: [:])
//            content.attachments = [attachment]
//        }catch{
//
//        }
        
        
        
        //Notification Action
        let action = UNNotificationAction.init(identifier: "Like", title: "Like", options: .foreground)
        let delete = UNNotificationAction.init(identifier: "Delete", title: "Delete", options: .destructive)
        let category = UNNotificationCategory.init(identifier: content.categoryIdentifier, actions: [action,delete], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
        
        
       
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "SelectionOrderWiseViewController")as! SelectionOrderWiseViewController
        self.navigationController?.pushViewController(newView, animated: true
        )
    }
    @IBAction func btnActionCameraAndGallery(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
                //here is the image
            self.imgViewStudent.image = image
            self.viewDidAppear(true)
            let DP = self.imgViewStudent.image
            print(DP as Any)
            self.saveselectedImage(img: DP!)
            }
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Functions
    func saveselectedImage(img:UIImage){
        //find path of document directory of my app
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
        //give a name to a file to save the image
        let name = txtFieldStudentName.text!
        let imagePath = pathArray[0] + "/\(name).png"
        // get binary data of selected image
        let profileImage = img.pngData()!
       
        
        //save binary data of image at imagepath
//        let fm:FileManager = FileManager.default
//        fm.createFile(atPath: imagePath, contents: profileImage, attributes: nil)
//        print("File Saved")
//        let imageData = fm.contents(atPath: imagePath)
        imageForStudent = profileImage
    }
}
//MARK: Extensions
