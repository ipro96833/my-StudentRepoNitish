//
//  AppDelegate.swift
//  StudentApp
//
//  Created by mac on 19/07/22.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseMessaging
import FirebaseAnalytics
import Messages

//c37650e09277916ce3e95bd10028486be3551667903b219b7fc613b765f6bc26
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var isFromNotification = false
var window: UIWindow?
let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.registerForRemoteNotification()
        print("Document Directory",FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        return true
    }
    
  
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
   
   
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StudentApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
//MARK: PushNotifications Methods
    @available(iOS 10, *)
    func registerForPushNotifications(application: UIApplication) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            notificationCenter.requestAuthorization(options: [.sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                    print("Unsuccessful in registering for push notifications")
                }
            })
        }
    @available(iOS 10, *)
      // Receive displayed notifications for iOS 10 devices.
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
    
        // With swizzling disabled you must let Messaging know about the message, for Analytics
       //  Messaging.messaging().appDidReceiveMessage(userInfo)
    
        // Print full message.
        print(userInfo)
    
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
      }
    @available(iOS 10, *)
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                          -> Void) {
    
          // If you are receiving a notification message while your app is in the background,
          // this callback will not be fired till the user taps on the notification launching the application.
         // TODO: Handle data of notification
    
          // With swizzling disabled you must let Messaging know about the message, for Analytics
           Messaging.messaging().appDidReceiveMessage(userInfo)
            guard let arrAps = userInfo["aps"] as? [String:Any] else{return}
            print(arrAps)
    
         // Print message ID.
          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
    
          }
    
          completionHandler(UIBackgroundFetchResult.newData)
        }
    @available(iOS 10, *)
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
    
        let userInfo = response.notification.request.content.userInfo
    
        // ...
    
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
    
    
          guard let nav = self.window?.rootViewController as? UINavigationController else{
    
       //      print("Error in Completion")
              return
          }
          nav.reloadInputViews()
          guard let arrAps = userInfo["aps"] as? [String:Any] else{return}
          print(arrAps)
          guard let arrAlert = arrAps["alert"] as? [String:Any] else { return }
          print(arrAlert)
          let strTitle:String = arrAlert["title"] as? String ?? ""
         print(strTitle)
        // Print full message.
    
          var queue = UserDefaults.standard
          if strTitle == "Notification"{
              queue.set(strTitle, forKey: "Data")
              if UserDefaults.standard.string(forKey: "Data") == "Notification"{
                  DispatchQueue.main.async(execute: {
                      let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      guard let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")as? LoginVC else{
                          return
                      }
                          nav.pushViewController(vc, animated: true)
                        self.window?.makeKeyAndVisible()
    
                  })
    
              }
          }else if strTitle == "Message"{
              queue.set(strTitle, forKey: "Data")
              if UserDefaults.standard.string(forKey: "Data") == "Message"{
                  DispatchQueue.main.async(execute:{
                      let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      guard let vc = storyboard.instantiateViewController(withIdentifier: "StudentRegistrationViewController")as? StudentRegistrationViewController else{
    
                          return
                      }
                          nav.pushViewController(vc, animated: true)
                          self.window?.makeKeyAndVisible()
    
                  })
    
              }
          }
         
    
            // This is where you read your JSON to know what kind of notification you received
    
    
          completionHandler()
      
}
}

//extension AppDelegate: UNUserNotificationCenterDelegate {

//}
extension AppDelegate: MessagingDelegate{
func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
  print("Firebase registration token: \(String(describing: fcmToken))")

  let dataDict: [String: String] = ["token": fcmToken ?? ""]
  NotificationCenter.default.post(
    name: Notification.Name("FCMToken"),
    object: nil,
    userInfo: dataDict
  )
  // TODO: If necessary send token to application server.
  // Note: This callback is fired at each app startup and whenever a new token is generated.
}
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = Messaging.messaging().fcmToken
        print(token ?? "nil")
        let deviceTokenString = deviceToken.hexString
        print(deviceTokenString)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError \(error.localizedDescription)")
    }
}
private extension AppDelegate{
    
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
            }
            UIApplication.shared.registerForRemoteNotifications()
        }else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
extension Data{
    var hexString: String{
        let hexString = map{ String(format: "%02.2hhx", $0)}.joined()
        return hexString
    }
}
