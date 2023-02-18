//
//  SlideInPresentationController.swift
//  ClickEvolution_iOS
//
//  Created by Shamsiddin on 3/29/19.
//  Copyright © 2019 Shamsiddin. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width*(1.0/3.0)
        case .bottom:
            if visibleHeight != 0 {
                frame.origin.y = containerView!.frame.height - visibleHeight
            } else {
                frame.origin.y = containerView!.frame.height*(1.0/3.0)
            }
           
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    fileprivate var dimmingView: UIView!
    
    // MARK: - Properties
    private var direction: PresentationDirection
    var visibleHeight: CGFloat = 0
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         direction: PresentationDirection, height: CGFloat) {
        self.direction = direction
        self.visibleHeight = height
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["dimmingView": dimmingView as Any]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [],
                                           metrics: nil,
                                           views: ["dimmingView": dimmingView as Any]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
        case .bottom, .top:
            return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
        }
    }
}

// MARK: - Private
private extension SlideInPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
