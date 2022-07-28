//
//  AlertViewController.swift
//  FamousFootPrints
//
//  Created by mac on 15/07/22.
//

import UIKit

class AlertViewController: UIViewController {
//MARK: Variables
    var text = UITextField()
    var titleForLabel:String = ""
    var message:String = ""
    var buttonTitleOk:String = ""
    var buttonTitleCancel:String = ""
    var indexEn:String?
    var indexAR:String?
    var lang = ""
    //MARK: Outlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnOutletOk: UIButton!
    @IBOutlet weak var btnOutletCancel: UIButton!
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurFx = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterialDark)
        let blurFxView = UIVisualEffectView(effect: blurFx)
        blurFxView.frame = view.bounds
        blurFxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurFxView.alpha = 0.60
       view.insertSubview(blurFxView, at: 0)
        contentView.layer.cornerRadius = contentView.frame.size.height/5
        contentView.layer.masksToBounds = true
        btnOutletOk.layer.cornerRadius = btnOutletOk.frame.height/5
        btnOutletOk.layer.masksToBounds = true
        btnOutletCancel.layer.cornerRadius = btnOutletCancel.frame.height/5
        btnOutletCancel.layer.masksToBounds = true
        lblTitle.text = titleForLabel
        lblMessage.text = message
        btnOutletOk.setTitle(buttonTitleOk, for: .normal)
        btnOutletCancel.setTitle(buttonTitleCancel, for: .normal)
        
    }
    //MARK: Button-Actions
    

    @IBAction func btnActionOkay(_ sender: UIButton) {
        if lang == "English"{
            languageSelection = false
            UserDefaults.standard.setValue(languageSelection, forKey: "languageSelection")
            if UserDefaults.standard.bool(forKey: "languageSelection") == false{
                languageSelection = false

                   UITextField.appearance().semanticContentAttribute = .forceLeftToRight
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
              

               // UIView.appearance().semanticContentAttribute = .forceLeftToRight
            //    UITextField.appearance().semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
                
            }
        }else if lang == "Arabic"{
            languageSelection = true
            UserDefaults.standard.setValue(languageSelection, forKey: "languageSelection")
            if UserDefaults.standard.bool(forKey: "languageSelection") == true{
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    UITextField.appearance().semanticContentAttribute = .forceRightToLeft
                
               
                   
             
            }
            
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")as! SettingsViewController
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    
    @IBAction func btnActionCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
