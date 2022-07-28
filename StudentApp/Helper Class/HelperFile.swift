//
//  HelperFile.swift
//  StudentApp
//
//  Created by mac on 21/07/22.
//

import Foundation
import UIKit

struct AnimalModal {
    let animal_scientifcName: String
    let symbol_picture: String
    let animal_category: String
    let animal_name: String
}

class HelperClass: UIViewController{
    static var sharedInstance = HelperClass()
    
    func alert(object:[String:String],controller: UIViewController){
        let alert = UIAlertController(title: object["title"], message: object["Message"], preferredStyle: .alert)
        let ok = UIAlertAction(title: object["titleMessage"], style: .default, handler: {
            action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
}

