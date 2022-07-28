//
//  LoginWithEmailViewController.swift
//  FamousFootPrints
//
//  Created by mac on 11/07/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import CryptoKit
import AuthenticationServices
import Alamofire
import SwiftyJSON
class LoginWithEmailViewController: UIViewController , UITextFieldDelegate{
    //MARK: Variables
    fileprivate var currentNonce: String?
//MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnOutletLoginWithPhone: UIButton!
    @IBOutlet weak var lblDonthaveanAccount: UILabel!
    @IBOutlet weak var btnOutletRegister: UIButton!
    @IBOutlet weak var btnOutletSignIn: UIButton!
    @IBOutlet weak var lblQuote: UILabel!
    @IBOutlet weak var btnOutletApple: UIButton!
    @IBOutlet weak var backHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleImageHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldPassword.isSecureTextEntry = true
        frameSelection()
        txtFieldEmail.text = "shinigamilight970@gmail.com"
        txtFieldPassword.text = "123@456789N123"
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "languageSelection") == true{
            languageChange(str: "ar")
        }else if UserDefaults.standard.bool(forKey: "languageSelection") == false{
            languageChange(str: "en")
        }
    }
    //MARK: Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFieldEmail.resignFirstResponder()
        txtFieldPassword.resignFirstResponder()
        return true
    }
    //MARK: Button-Actions

    @IBAction func btnActionSignIn(_ sender: UIButton) {
        let email = txtFieldEmail.text ?? "nil"
        let password = txtFieldPassword.text ?? "nil"
        
        let data = Login(email: email, password: password)
        
        AF.request("http://app.famousfootprints.com/api/user_login?email=\(email)&password=\(password)", method: .post, parameters: data, encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
            let resp = response.response?.statusCode ?? 0
            print(resp as Any)
            
            if response.data != nil && resp >= 200 && resp < 300 && self.txtFieldEmail.text?.isEmpty == false && self.txtFieldPassword.text?.isEmpty == false {
                let data:JSON = JSON(response.data!)
                let uid = data["user"]["uid"].string
                print((uid ?? "nil") as String)
                if uid != nil {
                    let dataID = uid
                    UserDefaults.standard.set(dataID, forKey: "user_id")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "HomeNavigationController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                }else{
                    ValidationManager.sharedManage.alertController(Title: "Alert!!!", userMessage: "Enter Valid Details!!!", controller: self)
                }
            }else{
                ValidationManager.sharedManage.alertController(Title: "Alert!!!", userMessage: "Enter Valid Details!!!", controller: self)
            }
        
        
    }
    }
    @IBAction func btnActionRegister(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController")as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnActionFaceBook(_ sender: UIButton) {
        getFacebookUserInfo()
    }
    
    @IBAction func btnActionGoogle(_ sender: UIButton) {
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else{ return }
            guard let user = user else{ return }
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let id = user.userID!
            print(id)
            print(emailAddress ?? "NA")
            print(fullName ?? "NA")
            print(user.profile as Any)
            user.authentication.do{authentication, error in
                guard error == nil else{ return }
                guard let authentication = authentication else { return }

                let idToken = authentication.idToken
                print("Token ID:",idToken ?? "NA")
            }
        }
    }
    
    @IBAction func btnActionTwitter(_ sender: UIButton) {
    }
    
    
    @IBAction func btnActionApple(_ sender: UIButton) {
        btnOutletApple.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
    }
    @objc func handleSignInWithAppleTapped(){
        performSignIn()
    }
    func performSignIn(){
        let requeset = createAppleIdRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [requeset])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    func createAppleIdRequest()-> ASAuthorizationAppleIDRequest{
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        return request
       
    }
   
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()
        
      return hashString
    }
//
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    //MARK: Functions
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email ], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    print(info["email"]as! String)
                }
                Connection.start()
            default:
                print("??")
            }
        }
    }
    func languageChange(str: String){
        lblTitle.text = "TitleRVC".localizableString(loc: str)
        lblDonthaveanAccount.text = "Already have an account?".localizableString(loc: str)
        btnOutletSignIn.setTitle("Log In".localizableString(loc: str), for: .normal)
        btnOutletRegister.setTitle("Register".localizableString(loc: str), for: .normal)
        btnOutletLoginWithPhone.setTitle("LogInPhone".localizableString(loc: str), for: .normal)
        lblQuote.text = "Text".localizableString(loc: str)
        txtFieldEmail.attributedPlaceholder = NSAttributedString(
            string: "Email".localizableString(loc: str),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        txtFieldPassword.attributedPlaceholder = NSAttributedString(
            string: "Password".localizableString(loc: str),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    func frameSelection(){
        if (self.view.frame.width == 320) {
          //  lblPrice.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
            backHeightConstraint.constant = 240
            titleImageHeightConstraint.constant = 240
            lblDonthaveanAccount.font = UIFont.systemFont(ofSize: 16,weight: .regular)

        } else if (self.view.frame.width == 375) {
            backHeightConstraint.constant = 60
            titleImageHeightConstraint.constant = 100
            lblDonthaveanAccount.font = UIFont.systemFont(ofSize: 19,weight: .regular)

        } else if (self.view.frame.width == 414) {
            backHeightConstraint.constant = 50
            titleImageHeightConstraint.constant = 100
            lblTitle.font = UIFont.systemFont(ofSize: 23,weight: .regular)
            lblDonthaveanAccount.font = UIFont.systemFont(ofSize: 21,weight: .regular)

        }
    }
    
}
//MARK: Extensions
extension LoginWithEmailViewController: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
            guard let nonce = currentNonce else{
                fatalError("Invalid State: A login callback was received but no login request was sent")
            }
            guard let appleIdToken = appleIdCredential.identityToken else{
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIdToken, encoding: .utf8) else{
                print("Unable to serialize token string from data: \(appleIdToken)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { authDataResult, error in
                if let user = authDataResult?.user{
                    print("Nice you're signed in as \(user.uid) email \(user.email ?? "unknown" )")
                }
            }
        }
    }
}
extension LoginWithEmailViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
