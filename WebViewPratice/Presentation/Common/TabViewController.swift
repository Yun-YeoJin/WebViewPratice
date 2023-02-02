//
//  TabViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setupTabBarAppearence()
        
    }
    
    private func setupTabBar(viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func configureTabBar() {
        
        let webVC = setupTabBar(viewController: SearchViewController(), title: "WebView", image: UIImage(systemName: "globe.asia.australia.fill")!)
        let safariVC = setupTabBar(viewController: SafariViewController(), title: "Safari", image: UIImage(systemName: "safari")!)
        
        setViewControllers([webVC, safariVC], animated: true)
    }
    
    private func setupTabBarAppearence() {
        
        let tabBarAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemBackground
        tabBarAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
        appearance.stackedLayoutAppearance = tabBarAppearance
        tabBar.standardAppearance = appearance
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemGreen
        
    }
    
    
    
}
