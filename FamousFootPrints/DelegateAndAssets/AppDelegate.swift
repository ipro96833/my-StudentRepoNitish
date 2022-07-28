//
//  AppDelegate.swift
//  FamousFootPrints
//
//  Created by mac on 04/07/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
let clientID = "96009452119-26h79616c8ffl8dc2fcvefmg3enn5j4j.apps.googleusercontent.com"
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        FirebaseApp.configure()
        if let user = Auth.auth().currentUser{
            print("You're sign in as \(user.uid)email \(user.email ?? "nil") ")
        }
        GMSServices.provideAPIKey("AIzaSyALzAcR4NE7HmJeLvYxGSeNZphE6BBq9YY")
        GMSPlacesClient.provideAPIKey("AIzaSyDgZnsbYL3VqU1Xdw8sM9-V8F0cwR4sr4I")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
          ApplicationDelegate.shared.application(
              application,
              open: url,
              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
              annotation: options[UIApplication.OpenURLOptionsKey.annotation]
          )
          
      return GIDSignIn.sharedInstance.handle(url)
    }
    
}

