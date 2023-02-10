//
//  SplashViewController.swift
//  WebViewPratice
//
//  Created by YEOJIN on 2023/02/10.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    
    let onboardingImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        splashAnimation()
        
    }
    
    private func splashAnimation() {
        
        self.onboardingImageView.alpha = 0 // 이미지의 투명도를 0으로 변경
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
            // 동작할 애니메이션에 대한 코드
            print("애니메이션 실행!")
            self.onboardingImageView.alpha = 1
            // 점진적으로 투명도가 1이 됩니다.
        }, completion: { finished in
            let vc = TabViewController()
            self.transition(vc, transitionStyle: .fullpresent)
        })
        
    }
    
    
    override func configureUI() {
        
        view.addSubview(onboardingImageView)
        
    }
    
    override func setConstraints() {
        onboardingImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(240)
        }
    }
    
}
