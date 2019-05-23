//
//  AppDelegate.swift
//  desafioIos
//
//  Created by Felipe Silva Lima on 5/11/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
            let realm = try Realm()
        }catch {
            print("Error initializing Realm: \(error)")
        }
        // Override point for customization after application launch.
        return true
    }
}

