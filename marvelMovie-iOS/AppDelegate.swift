//
//  AppDelegate.swift
//  marvelMovie-iOS
//
//  Created by Partha Pratim on 22/11/23.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
                
            } else {
                return vc;
            }
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var currentNavigation: UINavigationController?
    var currentNavicon: UINavigationController?
    var movieListCollectDataSync: MovieListCollectDataSync = MovieListCollectDataSync.sharedInstance
    var movieListViewController: MovieListViewController?
    var constants: Constants = Constants.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        self.movieListViewController = storyBoard.instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController
        let navCon = UINavigationController.init(rootViewController: movieListViewController!)
        navCon.navigationBar.isHidden = true
        navCon.toolbar.isHidden = true
        self.window?.rootViewController = navCon
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
    }
}

