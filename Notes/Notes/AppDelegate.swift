//
//  AppDelegate.swift
//  Notes
//
//  Created by Кристина Олейник on 12.08.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let navigationController = UINavigationController()
            let viewController = NotesListViewController()
            viewController.viewModel = NotesListViewModel()
            navigationController.viewControllers = [viewController]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
    }



}

