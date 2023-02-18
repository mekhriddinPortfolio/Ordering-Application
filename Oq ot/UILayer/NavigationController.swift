//
//  NavigationController.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 25/02/22.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        interactivePopGestureRecognizer?.delegate = self
    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if #available(iOS 13.0, *) {
//            return Theme.current.getThemeColor() == .dark ? .lightContent : .darkContent
//        } else {
//            return .default
//        }
//    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let vc = viewControllers.last {
            if let currentVC = vc as? BaseViewController {

                currentVC.back(with: .pop)
            }
            
        }
        return false
    }
    
    
}

extension NavigationController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }

}
