//
//  AppDelegate.swift
//  Bankey
//
//  Created by Mpilo Pillz on 2022/08/27.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let loginViewController = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        
        window?.rootViewController = loginViewController
        
        onboardingContainerViewController.delegate = self
        
        //        window?.rootViewController = onboardingContainerViewController
        //        window?.rootViewController = OnboardingContainerViewController()
        
        
        return true
    }
}

extension AppDelegate: LoginViewControllerDelegate, OnboardingContainerViewControllerDelegate {
    func didfinishOnboarding() {
        print("Did finish onboadring")
    }
    
    func didLogin() {
        setRootViewController(onboardingContainerViewController)
        //        window?.rootViewController = onboardingContainerViewController
        
    }
    
}

extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let  window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}



