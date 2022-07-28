//
//  NewViewController.swift
//  FamousFootPrints
//
//  Created by mac on 14/07/22.
//

import UIKit

class NewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK: Variables
    let arrLanguages = ["English","Arabic"]
    var check = UIImage(named: "checkRadio")
    var uncheck = UIImage(named: "uncheckRadio")
    
  
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let langStr = Locale.current.languageCode
        print(langStr as Any)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
  //MARK: Table-View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "DataCell")as! SelectLanguageTableViewCell
        cell.lblLanguage.text = arrLanguages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            print("English")
            let index = "English"
          
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "alert") as! AlertViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            let title = "Select Language"
            let titleMessage = "Are you sure you want to change the Language?"
            let ok = "OK"
            let cancel = "Cancel"
            vc.titleForLabel = title
            vc.message = titleMessage
            vc.buttonTitleOk = ok
            vc.buttonTitleCancel = cancel
            vc.lang = index
            self.present(vc, animated: true, completion: nil)
            
        }else if indexPath.row == 1{
            print("Arabic")
            let index = "Arabic"
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "alert") as! AlertViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            let title = "Select Language"
            let titleMessage = "Are you sure you want to change the Language?"
            let ok = "OK"
            let cancel = "Cancel"
            vc.titleForLabel = title
            vc.message = titleMessage
            vc.buttonTitleOk = ok
            vc.buttonTitleCancel = cancel
            vc.lang = index
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
