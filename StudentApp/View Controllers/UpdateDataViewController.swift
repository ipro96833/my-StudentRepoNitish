//
//  UpdateDataViewController.swift
//  StudentApp
//
//  Created by mac on 20/07/22.
//

import UIKit

class UpdateDataViewController: UIViewController {
   
    
    //MARK: Variables
    var dictStudentData:[String:String?] = [:]
    var i:Int = 0
    var data = Data()
    var imgData:Data?
    
    //MARK: Outlets
 
    @IBOutlet weak var imgViewStudent: UIImageView!
    @IBOutlet weak var btnOutletCamera: UIImageView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var txtFieldID: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var lblStandard: UILabel!
    @IBOutlet weak var txtFieldStandard: UITextField!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var txtFieldTeacher: UITextField!
    @IBOutlet weak var btnOutletUpdate: UIButton!
    @IBOutlet weak var txtFieldEnglish: UITextField!
    @IBOutlet weak var txtFieldHindi: UITextField!
    @IBOutlet weak var txtFieldMaths: UITextField!
    @IBOutlet weak var txtFieldSanskrit: UITextField!
    @IBOutlet weak var txtFieldScience: UITextField!
    @IBOutlet weak var txtFieldSocialScience: UITextField!
    @IBOutlet weak var txtFieldTotalMarks: UITextField!
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldName.text = dictStudentData["name"]!
        txtFieldID.text = dictStudentData["id"]!
        txtFieldStandard.text = dictStudentData["standard"]!
        txtFieldTeacher.text = dictStudentData["classTeacher"]!
        txtFieldTotalMarks.text = dictStudentData["totalMarks"]!
        if imgData != nil{
            imgViewStudent.image = UIImage(data:imgData!)!
        }else{
            imgViewStudent.image = UIImage(named: "addStudent")
        }
    }
    //MARK: Button Actions
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnActionUpdateDetails(_ sender: UIButton) {
        let dict = ["name": txtFieldName.text! , "standard":txtFieldStandard.text!, "id":txtFieldID.text!,"classTeacher":txtFieldTeacher.text!,"totalMarks":txtFieldTotalMarks.text!]
        let studentData = data
   
        CoreDataHelper.sharedInstance.update(object: dict, i: i, imgData: studentData)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnActionCamera(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
        self.imgViewStudent.image = image
        self.viewDidAppear(true)
        let DP = self.imgViewStudent.image
        print(DP as Any)
        self.saveselectedImage(img: DP!)
        }
        
    }
    
    //MARK: Functions
    func saveselectedImage(img:UIImage){
        //find path of document directory of my app
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
        //give a name to a file to save the image
        let name = dictStudentData["name"]
        let fullName = name!
        let imagePath = pathArray[0] + "/\(fullName!).png"
        // get binary data of selected image
        let profileImage = img.pngData()!
        data = profileImage
        //save binary data of image at imagepath
        let fm:FileManager = FileManager.default
        fm.createFile(atPath: imagePath, contents: profileImage, attributes: nil)
        print("File Saved")
    }
}
   //MARK: Extensions
 
