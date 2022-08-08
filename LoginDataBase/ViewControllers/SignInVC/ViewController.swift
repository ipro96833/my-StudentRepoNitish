//
//  ViewController.swift
//  LoginDataBase
//
//  Created by mac on 04/08/22.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit


class ViewController: UIViewController {
    //MARK: Variables
    fileprivate var currentNonce: String?
    

    
    //MARK: Outlets
    @IBOutlet weak var btnOutletSignIn: UIButton!
    
    
    //MARK: ViewController LifeCycle
   override func viewDidLoad() {
        super.viewDidLoad()
       
       
       
        // Do any additional setup after loading the view.
       if let userID = UserDefaults.standard.string(forKey: "userID") {
                   
           // get the login status of Apple sign in for the app
           // asynchronous
           if #available(iOS 13.0, *) {
               ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
                   credentialState, error in
                   
                   switch(credentialState){
                   case .authorized:
                       print("user remain logged in, proceed to another view")
                       self.performSegue(withIdentifier: "GetDataViewController", sender: nil)
                   case .revoked:
                       print("user logged in before but revoked")
                   case .notFound:
                       print("user haven't log in before")
                   default:
                       print("unknown state")
                   }
               })
           } else {
               // Fallback on earlier versions
           }
       }
       NotificationCenter.default.addObserver(self,selector: #selector(statusManager),name: .flagsChanged,object: nil)
              updateUserInterface()
    }

   
    //MARK: Button Actions
    
    
    @IBAction func btnActionSignIn(_ sender: UIButton) {
        if #available(iOS 13, *) {
           startSignInWithAppleFlow()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetDataViewController")as! GetDataViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    //MARK: Functions
    
    func updateUserInterface() {
            switch Network.reachability.status {
            case .unreachable:
                view.backgroundColor = .red
            case .wwan:
                view.backgroundColor = .yellow
            case .wifi:
                view.backgroundColor = .green
            }
            print("Reachability Summary")
            print("Status:", Network.reachability.status)
            print("HostName:", Network.reachability.hostname ?? "nil")
            print("Reachable:", Network.reachability.isReachable)
            print("Wifi:", Network.reachability.isReachableViaWiFi)
        }
        @objc func statusManager(_ notification: Notification) {
            updateUserInterface()
        }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
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
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
 
    
    @objc @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
        
}

//MARK: Extensions

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        // unique ID for the user
        let userID = appleIDCredential.user
      
        // save it to user defaults
        UserDefaults.standard.set(appleIDCredential.user, forKey: "userID")
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
              print(error?.localizedDescription)
          return
        }
          
          print(credential)
          let token = credential.idToken
          let name = authResult?.user.displayName
          let email = authResult?.user.email
          let phone = authResult?.user.phoneNumber
          let uuid = authResult?.user.uid
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetDataViewController")as! GetDataViewController
          vc.email = email ?? "nil"
          vc.token = token ?? "nil"
          vc.id = name ?? "nil"
          vc.number = phone ?? "nil"
          vc.uid = uuid ?? "nil"
          self.present(vc, animated: true, completion: nil)
          
        // User is signed in to Firebase with Apple.
        // ...
         
      }
    }
  }
   
            
        
    
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
extension ViewController: ASAuthorizationControllerPresentationContextProviding{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
