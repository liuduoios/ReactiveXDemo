//
//  AppDelegate.swift
//  ReactiveXDemo
//
//  Created by Derek Liu on 2016/12/8.
//  Copyright © 2016年 Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewModel = ViewModel()
        let viewController = ViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        
        window!.rootViewController = navigationController
        
        window!.makeKeyAndVisible()
        
        return true
    }
}

