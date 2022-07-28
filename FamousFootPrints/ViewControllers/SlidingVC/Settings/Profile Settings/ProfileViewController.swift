//
//  ProfileViewController.swift
//  FamousFootPrints
//
//  Created by mac on 08/07/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import ADCountryPicker
import SKActivityIndicatorView
import CoreLocation

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

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


class ProfileViewController: UIViewController,CLLocationManagerDelegate{
    //MARK: Variables
    var countryFlag = ""
   var code = ""
    var updateFlag = ""
    var countryImg = ""
    var getCode = ""
    var getImage:UIImage?
    let locationManager = CLLocationManager()
   
    //MARK: Outlets
    @IBOutlet weak var ProfileNB: UINavigationBar!
    @IBOutlet weak var imgViewCamera: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnOutletCountryFlag: UIButton!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblTextField: UITextField!
    @IBOutlet weak var btnOutletSubmit: UIButton!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var DPImageView: UIImageView!
    @IBOutlet weak var btnCameraOutlet: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtFieldCurrentLocation: UITextField!
    
    
    //MARK: ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       SKActivityIndicator.show("Loading...")
        self.getData()
        
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            languageCode(str: "ar")
            let locations = "Location".localizableString(loc: "ar")
            UITextField.appearance().semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
             UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            languageCode(str: "en")
            let locations = "Location".localizableString(loc: "en")
            UITextField.appearance().semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
             UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        ValidationManager.sharedManage.cornerRadius(img: imgViewCamera)
        ValidationManager.sharedManage.cornerRadius(img: DPImageView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        guard let currentLocation:CLLocation = locationManager.location else{return}
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        print(latitude,longitude)
      //  loadSavedImage()
     
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    // MARK: - Button-Actions
     @IBAction func btnActionCountryFlag(_ sender: UIButton) {
         let picker = ADCountryPicker(style: .grouped)
         // delegate
         picker.delegate = self

         // Display calling codes
         picker.showCallingCodes = true

         // or closure
         picker.didSelectCountryClosure = { name, code in
             _ = picker.navigationController?.popToRootViewController(animated: true)
             print(code)
             
         }
         let pickerNavigationController = UINavigationController(rootViewController: picker)
         self.present(pickerNavigationController, animated: true, completion: nil)
     }
    @IBAction func btnActionSubmit(_ sender: UIButton) {
        let user_id = UserDefaults.standard.string(forKey: "user_id") ?? "nil"
        print(user_id)
        let name = txtFieldName.text ?? "nil"
        let email = txtFieldEmail.text ?? "nil"
        let number = lblTextField.text ?? "nil"
        let countryCode = lblCountryCode.text ?? "nil"
       
      
        print(getCode)
        if lblCountryCode.text == getCode || lblCountryCode.text == "+\(getCode)" || lblCountryCode.text == "\(getCode)"{
            let picker = ADCountryPicker()
            let x = picker.getCountryName(countryCode: self.code)
           self.countryImg = x!
        }
        else{
            let x = self.updateFlag
            self.countryImg = x
            
        }
        print(self.updateFlag)
        print(self.countryImg)
        let img = DPImageView.image
        let user_img = img!
        print(user_img)
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
        //give a name to a file to save the image
        let imagePath = pathArray[0] + "/myPic.png"
        
        //get data of picture at imagepath
        let fm = FileManager.default
        let imageData = fm.contents(atPath: imagePath)
        //prepare image with image data
        
        let DisplayImage = UIImage(data: imageData!)
        DPImageView.image = DisplayImage
        self.getImage = DisplayImage
        let parameters = ["uid": user_id,
                          "name": name,
                          "email": email,
                          "phone": number,
                          "phone_code": countryCode,
                          ]
        let data = Update(uid:user_id,name: name, email: email, number: number, code: countryCode, countryName: self.countryImg)
        let imgData = DisplayImage!.jpegData(compressionQuality: 0.2)!
        AF.upload(multipartFormData: { multipartFormData in

                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    }

            if let jpegData = DisplayImage!.jpegData(compressionQuality: 1.0) {
                        multipartFormData.append(jpegData, withName: "user_img", fileName: "image", mimeType: "image/jpeg")
                    }
        }, to: "http://app.famousfootprints.com/api/update_settings",method: .post)
                .response { response in
                    if response.response?.statusCode == 200 {
                        print("OK. Done")
                print(debugPrint(response))
                    }
                }
    }
    @objc private func buttonTapped(_ sender: UIButton) {
        
     }
 
    @IBAction func barButtonActionBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Functions
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
        print(lat,lon)
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country as Any)
                        print(pm.locality as Any)
                        print(pm.subLocality as Any)
                        print(pm.thoroughfare as Any)
                        print(pm.postalCode as Any)
                        print(pm.subThoroughfare as Any)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        print(addressString)
                        
                        self.txtFieldCurrentLocation.text = addressString
                  }
            })
        }
    func getData(){
        let IDdata = UserDefaults.standard.string(forKey: "user_id")
        print(IDdata!)
        AF.request("http://app.famousfootprints.com/api/user_profile?uid=\(IDdata!)", method: .post, parameters: IDdata, encoder: JSONParameterEncoder.default).response{ [self]
            response in (debugPrint(response))
            let resp = response.response?.statusCode ?? 0
            print(resp)
            if resp >= 200 && resp < 300{
                let get = JSON(response.data!)
                let name = get["user"]["name"].string
                let email = get["user"]["email"].string
                let countryCode = get["user"]["phone_code"].string
                let number = get["user"]["phone"].string
                let country = get["user"]["country"].string
                let image = get["user"]["user_img"].url
                print(image as Any)
                let data = try? Data(contentsOf: image!)
                if let imgData = data{
                    let img = UIImage(data: imgData)
                    self.DPImageView.image = img!
                    print(img as Any)
                }
                self.txtFieldName.text = name ?? "nil"
                self.txtFieldEmail.text = email ?? "nil"
                self.lblCountryCode.text = countryCode ?? "nil"
                self.lblTextField.text = number ?? "nil"
                self.countryFlag = country!
                self.getCode = lblCountryCode.text ?? "nil"
                print(self.countryFlag)
                self.locale(for: self.countryFlag)
                if lblCountryCode.text == getCode || lblCountryCode.text == "+\(getCode)" || lblCountryCode.text == "\(getCode)"{
                let picker = ADCountryPicker()
                print(self.code)
                let x = picker.getFlag(countryCode: self.code)
                self.btnOutletCountryFlag.setImage(x, for: .normal)
                    
            }else{
                    let picker = ADCountryPicker()
                    print(updateFlag)
                    let x = picker.getFlag(countryCode: updateFlag)
                    self.btnOutletCountryFlag.setImage(x, for: .normal)
            }
            }
            if response.data != nil {
                DispatchQueue.main.async {
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.startUpdatingLocation()
                    guard let currentLocation:CLLocation = locationManager.location else{return}
                    let latitude = currentLocation.coordinate.latitude
                    let longitude = currentLocation.coordinate.longitude
                    getAddressFromLatLon(pdblLatitude: "\(latitude)", withLongitude: "\(longitude)")
                    SKActivityIndicator.dismiss()
                    //stoploader(loader: loader())
                }
            }
        }
        
    }
    private func locale(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                print(localeCode)
                self.code = localeCode
                return localeCode
                
            }
        }
        return locales
    }
    
    @IBAction func btnActionCameraAndGallery(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { image in
            self.DPImageView.image = image
            self.viewDidAppear(true)
            let DP = self.DPImageView.image
            print(DP as Any)
            self.saveselectedImage(img: DP!)
        }
    }
    
    func saveselectedImage(img:UIImage){
        //find path of document directory of my app
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(pathArray)
        //give a name to a file to save the image
        let imagePath = pathArray[0] + "/myPic.png"
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
        let imagePath = pathArray[0] + "/myPic.png"
        
        //get data of picture at imagepath
        let fm = FileManager.default
        let imageData = fm.contents(atPath: imagePath)
        //prepare image with image data
        
        let DisplayImage = UIImage(data: imageData!)
        DPImageView.image = DisplayImage
        self.getImage = DisplayImage
        
    }
    func languageCode(str:String){
        lblEmail.text = "Email".localizableString(loc: str)
        lblName.text = "Name".localizableString(loc: str)
        btnOutletSubmit.setTitle("Update Details".localizableString(loc: str), for: .normal)
    }
}
extension ProfileViewController: ADCountryPickerDelegate {

    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
//        countryNameLabel.text = name
//        countryCodeLabel.text = code
        lblCountryCode.text = dialCode
        
        print(name)
       // print(code)
       
       let x =  picker.getFlag(countryCode: code)
        
       // let xx =  picker.getCountryName(countryCode: code)
       // let xxx =  picker.getDialCode(countryCode: code)
        btnOutletCountryFlag.setImage(x, for: .normal)
        let countryName = picker.getCountryName(countryCode: code)
        print(countryName!)
        self.updateFlag = countryName!
    }
}
