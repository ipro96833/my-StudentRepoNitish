//
//  ViewController.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit


class LoginVC: UIViewController {
    //MARK: Variables
    
//MARK: Outlets
    
    
    @IBOutlet weak var txtFieldAdminId: UITextField!
    
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    
    @IBOutlet weak var btnOutletLogin: UIButton!
    
    
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
           if appDelegate.isFromNotification {
               appDelegate.isFromNotification = false
               //Push to your notification controler without animation
           }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        UserDefaults.standard.set("", forKey: "Data")
    }
    //MARK: Button Actions
    
    @IBAction func btnActionLogin(_ sender: UIButton) {
        let title = txtFieldAdminId.text
        let message = txtFieldPassword.text
        do{
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAFlqb-lc:APA91bGNeBnPJW0i3ObaVn37HrkbfQBnVAIEyWe1bP0VptWPIkepCrLkYEv2hx6w8ikh-wpfdkwOB_Axw74e55QJtvudBjN8bWh6lu9fd8_o22tVctFB1l1L9VpAUCLcTMelusyiGO5o", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let notData: [String: Any] = [
            "to" : "eLx4UUZn90xSlvsmjjYzQg:APA91bHfpBAIS6k7p-tlW_f6tm4-3sVvE0TYidj9fzm-g-Bo-gRKHxMbYKr72WXfJzUGg39gVmaFlRmVXVsQsGoX_zpfiK4rP6XVRk2-Uva02ljUdD9gPZ4pdS-x7fofXbEPyz1hM8dv",
                "notification": [
                  "title" : title!,
                  "body"  : message!,
                ],
                
        ]
            let jsonData:Data = try JSONSerialization.data(withJSONObject: notData, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request, completionHandler: updateData(data:response:error:))
        task.resume()
        
        }catch{
            print("Error",error)
        }
        
        
        
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeTitlesViewController")as! WelcomeTitlesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Functions
    func updateData(data:Data?, response:URLResponse?, error:Error?) -> Void{
        if data != nil && error == nil{
            let resp = (response as! HTTPURLResponse).statusCode
            print(resp)
            let str = String(data: data!, encoding: String.Encoding.utf8)
            print("JSON",str!)
        }
    }
    
}

//MARK: Extensions
