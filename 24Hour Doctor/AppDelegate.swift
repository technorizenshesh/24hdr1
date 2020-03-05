//
//  AppDelegate.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//


//App Name - Snapreads
//
//App Url - https://apps.apple.com/us/app/snapreads-read-more-books/id1276184542
//
//Description - Using Snapreads is simple. Download the app now and sign up for the free 7-day trial.
//Snapreads offers two membership options: Monthly subscription for $14.99/month (First week free) and a yearly membership (First week free) for $89.99/year.
//You can cancel at any time during your 7-day free trial via the iTunes store settings and you will not be charged. Plans automatically renew unless you turn off auto-renew in your iTunes account 24 hours before the end of your current subscription period. Any unused portion of a free trial period will be forfeited when the purchase of a subscription to that publication.
//
///**************************************
//
// App Name - Ng Rewards
//
// App url - https://apps.apple.com/us/app/ng-rewards/id1468289927?ls=1
//
// Descr - With the NG Rewards app, it pays to be a loyal customer.
//
// Earn NGCash in-store or in-app.
// Every time you pay through the NG Rewards app you accumulate NGCash. And every time you refer friends with your username, you earn even more NGCash. NG Rewards works with participating local brands and retailers.
// Start earning NGCash today and download the free app now!
// HOW THE NG REWARDS APP WORKS:
// 1. Nearby - Find a participating local brand you would like to shop from.
// 2. Pay Bill - Pay the Merchant through the NG Rewards app.
// 3. Redeem NGCash - Shop with your NGCash in full or partially.
// 4. Get NGCash - Watch your NGCash balance grow!
// NG Rewards is the best way to get rewarded for being loyal.
//
// /*************************************
//
// App Name - Fixezi
//
// App Url - https://apps.apple.com/us/app/fixezi-the-app-of-all-trades/id1478120463?ls=1
//
// Descri - Fixezi-The App of All Trades, is a trade-based app on smart phones and website, it’s for every home/business/realtor or tradesmen looking for quality, professional and reliable trade’s people that are local in Perth, WA, all listed in a fast, simple and reliable to use app. 
//So how does it work?
// It's a brand new app for Perth, WA, it's free to download and use, tradesman can sign up for free, there's no subscription fee, so tradesman can stay on the app for as long as they want, and don't have to pay a cent unless they accept work. 
//Fixezi -The App Of All Trades, makes it easy to search for a local qualified tradesman, with prices and a rating system for every tradesmen listed with us, so selecting the right tradesman is totally up to you.  
//
// /***********************************
//
// App name - AgendaMap
//
// App url - https://apps.apple.com/us/app/agendamap/id1437355446?ls=1
//
// Descr. AgendaMap is an utility APP dedicated to small businesses and freelancers that always work on the move, to help them share geolocated data and basic information about clients present within their work group.
//
// Coming from the need to assign personal data and categories to places of interest it was developed with the addition of practical features like the calendar, things to do, road route calculation, reminder, quick phone call and a small dashboard with reference charts.
//
// The intent of this App is to share the basic data of each client for their work group and in real time, so as to reduce the briefing activities for updating information on each individual client. -
//
// /*************************************
//
// App Name - Kizmi
//
// App url - https://apps.apple.com/us/app/kizmi/id1317656770
//
// Desc -  Living out of your home country ? Want to hang out or match up with people from your culture ? Your profile gets lost in millions of profiles on other commonly used dating apps of the country you are living in . We have made this app for Non Resident Indians (NRI's) to get matched with each other .
//
// /**********************************
//
// AppName - Easymove
//
// Appurl User - https://apps.apple.com/us/app/easymovemo/id1467729800?ls=1
//
// AppUrl driver - https://apps.apple.com/us/app/easydrivemo/id1467747831?ls=1
//
// Desc - Easymovemo Cars app offers the easiest and fastest way to get a taxi or Easymovemo Cars. Enjoy an inexpensive

 //AppName - https://apps.apple.com/us/app/mudameter/id1230399020

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import UserNotifications

let gClientId = "438689410967-n9kfle7tbre0l36ujnofq5pjksgec8r0.apps.googleusercontent.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var token = "iOS123"
    var userId = ""
    var userInfo = NSMutableDictionary()
    var currentLocation: CLLocation? = nil
    var locationManager = CLLocationManager()
    var userType = "doctor"
//dfdjf
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        GIDSignIn.sharedInstance().clientID = "419884191123-1fnqh9kq14dlgfgubqiq1vis6i3h2ddk.apps.googleusercontent.com"
//        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
//            statusBar.backgroundColor = PredefinedConstants.statusBarColor()
//            statusBar.setValue(PredefinedConstants.statusBarColor(), forKey: "foregroundColor")
//        }
        GIDSignIn.sharedInstance().clientID = gClientId
        IQKeyboardManager.shared.enable = true
        registerForPushNotification()
        requestForLocation()
        manageSession()
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
    }
    
    //MARK: SESSION
    func manageSession() {
        if let data = UserDefaults.standard.data(forKey: keyUserInfo) {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
                print("userInfo-\(dict)-")
                userId = string(dict, "id")
                userInfo = dict.mutableCopy() as! NSMutableDictionary
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "RootView") as! RootView
                window?.rootViewController = vc
            }
        }
    }
    
    func saveUser(_ dict: NSDictionary) {
        let encodeData = NSKeyedArchiver.archivedData(withRootObject: dict)
        UserDefaults.standard.set(encodeData, forKey: keyUserInfo)
        userInfo = dict.mutableCopy() as! NSMutableDictionary
        userId = string(dict, "id")
    }
    
    func logOut() {
        userId = ""
        userInfo.removeAllObjects()
        UserDefaults.standard.removeObject(forKey: keyUserInfo)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "startNav")
        kAppDelegate.window?.rootViewController = vc
    }
    
    //MARK: REQUEST FOR LOCATION
    func requestForLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            /*let encodeData = NSKeyedArchiver.archivedData(withRootObject: currentLocation!)
            UserDefaults.standard.set(encodeData, forKey: "LastLocation")
            UserDefaults.standard.synchronize()*/
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func checkUsersLocationServicesAuthorization() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Full Access")
                return true
                
            case .notDetermined:
                requestForLocation()
                return false
                
            case .restricted, .denied:
                Http.alert("Allow Location Access", "24hDr needs access to your location. Turn on Location Services in your device settings.")
                return false
            }
        } else {
            Http.alert("Allow Location Access", "24hDr needs access to your location. Turn on Location Services in your device settings.")
            return false
        }
    }
    
    //MARK: NOTIFICATIONS
    func registerForPushNotification()  {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map{ data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        token = tokenParts.joined()
        print("deviceToken-\(token)-")
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error-\(error.localizedDescription)-")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    var obChat: ChatVC? = nil
    var obConversation: ConversationsVC? = nil
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo-\(userInfo)-")
        if let dict = userInfo["aps"] as? NSDictionary {
            
            /*if string(dict, "key") == "You have a new chat message" {
             if obChat != nil {
             if obChat!.isBuyChat {
             obChat?.wsRefreshBuyConversation()
             } else {
             obChat?.wsRefreshSellConversation()
             }
             
             } else if obConversation != nil {
             obConversation?.wsRefreshConversation()
             }
             }*/
        }
    }
    
    func goToChatScreen(_ dict: NSDictionary) {
        let alert = UIAlertController(title: appName, message: string(dict, "title"), preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "See", style: .default, handler: { action in
            
            let state = UIApplication.shared.applicationState
            /*if state == .background  || state == .inactive{
             let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
             let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBar
             vc.selectedIndex = 3
             }else if state == .active {
             let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
             let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBar
             vc.selectedIndex = 3
             self.window?.rootViewController = vc
             }*/
        })
        
        let actionCancel = UIAlertAction(title: "Later", style: .destructive, handler: { action in
            print("action cancel handler")
        })
        
        alert.addAction(actionYes)
        alert.addAction(actionCancel)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: FACEBOOK, GOOGLE
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return handled
    }


}

