//
//  AppDelegate.swift
//  pushnotification
//
//  Created by user on 20.12.2021.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        permissionForPushNotifications()
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
    
    
}

// MARK: - Push Notifications


extension AppDelegate {
    
    /// Запрос на разрешение пушей
    func permissionForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                guard let self = self else { return }
                print("Registered to APNs: \(granted)")
                guard granted else { return }
                self.registerForPushNotifications()
            }
    }
    
    /// Регистрация если пользователь разрешил
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            print("Notification settings: \(settings)")
        }
    }
    
    /// Регистрация успешна (получили токен)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        
        print("Token: \(token)")
    }
    
    /// Регистрация НЕ успешна
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// Пришел пуш когда приложение открыто
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    /// Пользователь нажал на пуш
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String: AnyObject],
              let notificationData = aps["notificationData"] as? String
        else {
            completionHandler()
            return
        }

        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController as? ViewController else {
            completionHandler()
            return
        }
        
        viewController.pushText = notificationData
        
        completionHandler()
    }
}
