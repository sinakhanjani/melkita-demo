//
//  AppDelegate.swift
//  Master
//
//  Created by Sinakhanjani on 10/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import RestfulAPI


struct RefreshTokenSend: Codable {
    let refreshToken: String
}

// MARK: - RefreshTokenRecieved
struct RefreshTokenRecieved: Codable {
    let isSuccess: Bool
    let accessToken, refreshToken: String
}

let BASE_URL = "https://api.melkita.com/api/v1"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    fileprivate let viewActionIdentifier = "VIEW_IDENTIFIER"
    fileprivate let newsCategoryIdentifier = "NEWS_CATEGORY"

    static var fcmToken: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //GMSServices.provideAPIKey(Constant.Google.api)
        //GMSPlacesClient.provideAPIKey(Constant.Google.api)
        RestfulAPIConfiguration().setup { () -> APIConfiguration in
            APIConfiguration(baseURL: BASE_URL,
                             headers: [:])
        }
        print(Authentication.user.token)
        AppDelegate.fetchRole()
        AppDelegate.fetchUserInfoRequest()
        fetchSetting()
        ErsalMadarekTableViewController.fetchDocumentStatus { _ in}
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.persianFont(size: 10)], for: .normal)

        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0
        setupPushNotification(application)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Master")
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
    
    func fetchSetting() {
        RestfulAPI<EMPTYMODEL,RCSetting>.init(path: "/Common/setting")
            .with(method: .GET)
            .sendURLSessionRequest { results in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let setting):
                        DataManager.shared.setting = setting
                        break
                    default:
                        break
                    }
                }
            }
    }
    
    static func fetchRole() {
        RestfulAPI<EMPTYMODEL,GenericOrginal<String>>.init(path: "/User/role")
            .with(method: .GET)
            .with(auth: .user)
            .sendURLSessionRequest { results in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let role):
                        DataManager.shared.role = RoleEnum.init(rawValue: role.data ?? "")
                        break
                    default:
                        break
                    }
                }
            }
    }
    
    static func fetchUserInfoRequest() {
        RestfulAPI<Empty,RCUserInfo>.init(path: "/User/info")
        .with(auth: .user)
        .with(method: .GET)
        .sendURLSessionRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    DataManager.shared.userInfo = res
                    break
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

//NOTIFICATION
extension AppDelegate {
    func setupPushNotification(_ application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "NO TOKEN!")")
        if let fcmToken = fcmToken {
            AppDelegate.updateFCMToken(token: fcmToken)
        }
        AppDelegate.fcmToken = fcmToken ?? "BAD FCM TOKEN"
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String.init(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("didRegiste rForRemoteNotificationsWithDeviceToken")
        print("Push Notification Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let state = application.applicationState
        print(userInfo,state)
         completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
         // Print full message.
         print(userInfo)
        completionHandler()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    // MARK: Topics ----
    func addtoTopic(to: String) {
        Messaging.messaging().subscribe(toTopic: to) { (err) in
            print("Subscribed to \(to) topic")
        }
    }
    
    func removetoTopic(from: String) {
        Messaging.messaging().unsubscribe(fromTopic: from) { (err) in
            if err == nil {
                print("Unsubscribe to \(from) topic")
            }
        }
    }
    
    static func updateFCMToken(token: String) {
        struct Send: Codable {
            let deviceTokenId: String
            let type = 2
        }
            RestfulAPI<Send,EMPTYMODEL>.init(path: "/Auth/updateFcmToken")
            .with(auth: .user)
            .with(method: .POST)
            .with(body: Send(deviceTokenId: token))
            .sendURLSessionRequest { (_) in
                //
            }
    }
}
