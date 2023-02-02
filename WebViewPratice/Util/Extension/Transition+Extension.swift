//
//  Transition+Extension.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/02.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present //네비게이션 없이 present
        case presentNavigation //네비게이션 임베드 present
        case presentFullNavigation //네비게이션 풀스크린
        case push //푸시
        case pop //팝
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true) //self.present(T(), animated: true)와 차이.
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .pop:
            self.navigationController?.popToViewController(viewController, animated: true)
        }
    }
}
