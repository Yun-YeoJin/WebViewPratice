//
//  UIViewController+Extension.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/03.
//

import UIKit

extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    // 최상위 뷰컨트롤러를 판단하는 메서드
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
            
        } else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
            
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
    }
    
    func showConfirm(title: String, message: String, btnTitle: String, btnStyle: UIAlertAction.Style, okBtnAction: @escaping ((UIAlertAction) -> Void ), cancelBtnAction: @escaping ((UIAlertAction) -> Void )) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: btnStyle, handler: cancelBtnAction)
        let ok = UIAlertAction(title: btnTitle, style: btnStyle, handler: okBtnAction)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    func showAlert(title: String, message: String, btnTitle: String, btnStyle: UIAlertAction.Style, okBtnAction: @escaping ((UIAlertAction) -> Void ), cancelBtnAction: @escaping ((UIAlertAction) -> Void )) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: btnTitle, style: btnStyle, handler: okBtnAction)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        
        Preview(viewController: self)
    }

    func showPreview(_ deviceType: DeviceType = .iPhone13Pro) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif

