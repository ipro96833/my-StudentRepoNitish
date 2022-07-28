//
//  SelectLanguageVC.swift
//  FamousFootPrints
//
//  Created by mac on 04/07/22.
//

import UIKit
//MARK: Global Variables
var languageSelection = false
class SelectLanguageVC: UIViewController {
//MARK: Outlets
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var btnLanguageSelectionOutlet: UIButton!
    @IBOutlet weak var btnOutletNext: UIButton!
    
    //MARK: ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    //MARK: Button-Actions
    
    @IBAction func btnActionLanguage(_ sender: UIButton) {
        self.languageChange(strLanguage: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
    UITextField.appearance().semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC")as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
     languageSelection = true
     UserDefaults.standard.set(languageSelection, forKey: "languageSelection")
    UserDefaults.standard.set("ar", forKey: "languageCode")
    }
    
   
    @IBAction func btnActionNext(_ sender: UIButton) {
        self.languageChange(strLanguage: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC")as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
        languageSelection = false
        UserDefaults.standard.set(languageSelection, forKey: "languageSelection")
        UserDefaults.standard.set("en",forKey: "languageCode")
    }
    
    //MARK: Functions
    func languageChange(strLanguage: String){
        lblHeader.text = "Welcome to footprintsKey".localizableString(loc: strLanguage)
        lblSelectLanguage.text = "Please select a languageKey".localizableString(loc: strLanguage)
        btnLanguageSelectionOutlet.setTitle("Language".localizableString(loc: strLanguage), for: .normal)
        btnOutletNext.setTitle("Next".localizableString(loc: strLanguage), for: .normal)
        
    }
}
