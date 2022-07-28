//
//  ValidationManager.swift
//  FamousFootPrints
//
//  Created by mac on 05/07/22.
//
import Foundation
import UIKit
import Alamofire

struct Register: Encodable{
    let name: String
    let email: String
    let phone_code: String
    let phone: String
    let password: String
}

struct Login: Encodable{
    let email: String
    let password: String
}
struct Update: Encodable{
    let uid: String
    let name: String
    let email: String
    let number: String
    let code: String
    let countryName: String
}

class ValidationManager: UIViewController {
    static let sharedManage = ValidationManager()
    
    func alertController(Title:String,userMessage:String, controller: UIViewController){
        let alert = UIAlertController(title: Title, message: userMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func strReturn(date: String) -> String {
        let a = ""
        return a
        
    }
    func cornerRadius(img:UIImageView){
        img.layer.cornerRadius = img.frame.size.height/2
        img.layer.masksToBounds = true
    }
}

