//
//  AppDelegate.swift
//  Todoey
//
//  Created by Reshmi Kalpavraksh on 1/4/19.
//  Copyright © 2019 Reshmi Kalpavraksh. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
   //     print(Realm.Configuration.defaultConfiguration.fileURL)
    
        do {
            let _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }
    
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
}

