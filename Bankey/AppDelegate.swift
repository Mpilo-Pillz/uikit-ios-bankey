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
//    var hasOnboarded = false
    
    let loginViewController = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    let homeViewController = HomeViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        
        window?.rootViewController = loginViewController
        
        onboardingContainerViewController.delegate = self
        homeViewController.logoutDelegate = self
        
        //        window?.rootViewController = onboardingContainerViewController
        //        window?.rootViewController = OnboardingContainerViewController()
        
        
        return true
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

extension AppDelegate: LoginViewControllerDelegate, OnboardingContainerViewControllerDelegate {
    func didfinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(homeViewController)
    }
    
    func didLogin() {
        if LocalState.hasOnboarded {
            setRootViewController(homeViewController)
        } else {
            setRootViewController(onboardingContainerViewController)
        }
        //        window?.rootViewController = onboardingContainerViewController
        
    }
    
}

extension AppDelegate: LogoutDelegate {
    func didLogout() {
        setRootViewController(loginViewController)
    }
}





