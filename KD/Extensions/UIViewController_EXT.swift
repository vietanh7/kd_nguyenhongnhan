//
//  UINavigationController_EXT.swift
//

import UIKit
import SWRevealViewController
import KRProgressHUD

extension UIViewController {
    var isModalPresenting: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    func startLoadingAnimation() {
        DispatchQueue.main.async {
            let loadingAnimation      = VW_LoadingAnimation()
            loadingAnimation.isHidden = false
            self.view.addSubview(loadingAnimation)
            loadingAnimation.snp.makeConstraints { (make) in
                make.center.size.equalToSuperview()
            }
        }
    }

    func getStartLoadingAnimation() -> UIView {
        let loadingAnimation      = VW_LoadingAnimation()
        loadingAnimation.isHidden = false
        self.view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }

        return loadingAnimation
    }

    func endLoadingAnimation() {
        DispatchQueue.main.async {
            for view in self.view.subviews {
                if view .isKind(of: VW_LoadingAnimation.self) {
                    UIView.animate(withDuration: 1.0) {
                        view.alpha = 0.0
                    } completion: { (_) in
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }

    func startLoadingAnimationTimer(duration: Double) {
        let loadingAnimation      = VW_LoadingAnimation()
        loadingAnimation.isHidden = false
        self.view.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }

        UIView.animate(withDuration: duration, animations: {
            loadingAnimation.alpha = 0.0
        }, completion: { (_: Bool) in
            loadingAnimation.removeFromSuperview()
        })
    }
    
    
    // MARK: - Custom Alert
    func showAlert(imageName: String? = nil, title: String, message: String, positiveTitleButton: String?, positiveCompletion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertViewController = BasicAlertViewController(alertType: .warning, imageName: imageName, title: title, message: message, positiveTitleButton: positiveTitleButton)
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen

            alertViewController.show(animated: true, completion: nil)
            
            alertViewController.didPositiveButtonTapped = {
                positiveCompletion?()
            }
        }
    }
    
    func showConfirmAlert(imageName: String? = nil, title: String, message: String, negativeTitleButton: String?, positiveTitleButton: String?, positiveCompletion: @escaping () -> Void, negativeCompletion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertViewController = BasicAlertViewController(alertType: .confirmation, imageName: imageName, title: title, message: message, negativeTitleButton: negativeTitleButton, positiveTitleButton: positiveTitleButton)
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen

            alertViewController.show(animated: true, completion: nil)
            
            alertViewController.didPositiveButtonTapped = {
                positiveCompletion()
            }
            alertViewController.didNegativeButtonTapped = {
                negativeCompletion?()
            }
            
        }
    }
    
    // MARK: - Loading HUD
    func showLoading() {
        
        if KRProgressHUD.isVisible { return }
        
        KRProgressHUD.appearance().activityIndicatorColors = [UIColor.init(hexString: "0335fc") ?? .red, .white]
        KRProgressHUD.show()
    }
    
    func hideLoading() {
        KRProgressHUD.dismiss()
    }

}
