//
//  AppDelegate.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 04/07/22.
//

import UIKit
import YandexMapsMobile
let yandexGeneralApiKey = "b5569b0b-1f59-4fb2-8708-d29d363c1d8b"
let yandexGeocodeKey = "ba8e6cee-6cf9-4d76-976d-14da6bb1c3ca"
var jsonLog = true

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        YMKMapKit.setApiKey(yandexGeneralApiKey)
        YMKMapKit.sharedInstance()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        self.window?.backgroundColor = .clear
        self.configPushNotifications(application)
        refreshToken()
        setRoot(viewController: VideoLaucherVC())
        return true
    }
    
    
    
    
    func setRoot(viewController: UIViewController?) {
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
    func configPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "OQ-OT"
        notificationContent.subtitle = "keldi"
        notificationContent.body = "Ваш заказ начали собирать, пожалуйста заполните все данные"
        notificationContent.badge = NSNumber(value: 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return .portrait
    }
    
    func getDisplayedVC() -> BaseViewController? {
        if let mainTVC = window?.rootViewController?.children.last as? MainTabbarController {
            return mainTVC.selectedViewController?.children.last as? BaseViewController
        } else {
            return (window?.rootViewController as? MainTabbarController)?.selectedViewController?.children.last as? BaseViewController
        }
    }
    
    private func refreshToken() {
        let url = URL(string: "http://128.199.25.228:5056/api/1.0/refresh")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        request.httpMethod = "POST"
        if let token = UD.token {
            let data = ("\(token)" as NSString).data(using: String.Encoding.utf8.rawValue)
            request.httpBody = data
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo.count)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    
    
    
}

