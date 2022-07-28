//
//  RegisterViewController.swift
//  FamousFootPrints
//
//  Created by mac on 07/07/22.
//

import UIKit
import ADCountryPicker
import Alamofire
import SwiftyJSON
class RegisterViewController: UIViewController {
    //MARK: Variables
    var country = ""
    
    //MARK: Outlets
    
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldNumber: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var btnOutletCountryFlag: UIButton!
    @IBOutlet weak var lblAlreadyHaveanAccount: UILabel!
    @IBOutlet weak var btnOutletLogin: UIButton!
    @IBOutlet weak var btnOutletRegister: UIButton!
    @IBOutlet weak var lblQuote: UILabel!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    
    
    
    //MARK: ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldPassword.isSecureTextEntry = true
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            languageChange(str: "ar")
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            languageChange(str: "en")
        }
    
    }
    //MARK: Button-Actions

   
    
    @IBAction func btnActionSelectCountryCode(_ sender: UIButton) {
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
    
    
    @IBAction func btnActionLogin(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LogInVC")as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
//       let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewViewController")as! NewViewController
//       self.present(vc,animated: true,completion: nil)
    }
    
    @IBAction func btnActionRegister(_ sender: UIButton) {
        let name = txtFieldName.text ?? "nil"
        let email = txtFieldEmail.text ?? "nil"
        let phoneCode = lblCountryCode.text ?? "nil"
        let number = txtFieldNumber.text ?? "nil"
        let password = txtFieldPassword.text ?? "nil"
        let country = self.country
        
        let data = Register(name: name, email: email, phone_code: phoneCode, phone: number, password: password)
        AF.request("http://app.famousfootprints.com/api/user_registration?name=\(name)&email=\(email)&phone_code=\(phoneCode)&country=\(country)&number=\(number)&password=\(password)", method: .post, parameters: data, encoder: JSONParameterEncoder.default).response{ response in debugPrint(response)
            print(response)
            let json = JSON(response.data!)
            let userName = json["status"].string
            let us = json["msg"].string
            let status = userName ?? "nil"
            let msg = us ?? "nil"
                ValidationManager.sharedManage.alertController(Title: status, userMessage: msg, controller: self)
           
            if msg == "You have successfully registered an account"{
                let passData: JSON = JSON(response.data!)
                let data = passData["user"]["name"].string
                let data1 = passData["user"]["email"].string
                print(data!)
                print(data1!)
            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
            
                
        }
    
    }
   
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    
    //MARK: Functions
     func languageChange(str: String){
         lblTitle.text = "TitleRVC".localizableString(loc: str)
         lblAlreadyHaveanAccount.text = "Already have an account?".localizableString(loc: str)
         btnOutletLogin.setTitle("Log In".localizableString(loc: str), for: .normal)
         btnOutletRegister.setTitle("Register".localizableString(loc: str), for: .normal)
         lblQuote.text = "Text".localizableString(loc: str)
         txtFieldName.attributedPlaceholder = NSAttributedString(
             string: "FullName".localizableString(loc: str),
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         )
         txtFieldEmail.attributedPlaceholder = NSAttributedString(
             string: "Email".localizableString(loc: str),
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         )
         txtFieldNumber.attributedPlaceholder = NSAttributedString(
             string: "Enter Number".localizableString(loc: str),
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         )
         txtFieldPassword.attributedPlaceholder = NSAttributedString(
             string: "Password".localizableString(loc: str),
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         )
         
     }

}
extension RegisterViewController: ADCountryPickerDelegate {

    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
//        countryNameLabel.text = name
//        countryCodeLabel.text = code
        self.country = name
        lblCountryCode.text = dialCode

       let x =  picker.getFlag(countryCode: code)
       // let xx =  picker.getCountryName(countryCode: code)
       // let xxx =  picker.getDialCode(countryCode: code)
        btnOutletCountryFlag.setImage(x, for: .normal)
    }
}
