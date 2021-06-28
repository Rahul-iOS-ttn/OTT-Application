//
//  AppDelegate.swift
//  OTT-Applcation
//
//  Created by TTN on 23/06/21.
//

import UIKit
import SocialLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let navController = UINavigationController(rootViewController: ViewController.viewController())
//        window?.rootViewController = navController
        
        
        do {
            try ANAuthService.shared.setUpLoginService(setUpConfig: ANAuthServiceSetupConfig(application: application, loginOptions: launchOptions, googleClientId: "1086721698817-gg3c8o60hht6gm7b3qljc6s01ea4qtoe.apps.googleusercontent.com", keychainServiceName: "com.loginmodule"))
            
        } catch ANSignInError.setupError(let typeOfSignIn) {
            
            switch typeOfSignIn {
            case .google:
                print("Google login set up failed")
            case .facebook:
                print("Facebook login set up failed")
            case .apple:
                print("Apple sing in set up failed")
            default:
                print("Other login set up failed")
            }
        }  catch {
            print("Unkowen error")
        }
        
        
        
        
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


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        return ANAuthService.shared.handle(app, open: url, options: options)
        

    }
    
    
}


