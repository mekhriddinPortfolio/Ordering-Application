//
//  BaseViewController.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 25/02/22.
//

import UIKit
import CoreData

enum BackRoute {
    case toRoot
    case pop
    case toOrigin
    case dismiss
    case dismissAll
}

class BaseViewController: UIViewController {
    var backButton: UIBarButtonItem?
    private let slide = SlideInPresentationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.viewControllers.count != 1 {
            self.showBackButton()
        }
    }
    
    lazy var processingView = {
        return ProgressView(frame: CGRect(origin: .zero,
                                          size: SCREEN_SIZE))
    }()
    
    lazy var topBackgroundImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "pattern")?.withRenderingMode(.alwaysTemplate)
        im.contentMode = .scaleAspectFill
        im.tintColor = .white
        return im
    }()
    
    public func setViewSettingWithBgShade(view: UIView)
    {
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        //MARK:- Shade a view
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
    }
    
    func addBorderGradient(to view: UIView, colors: [CGColor], lineWidth: CGFloat, startPoint: CGPoint, endPoint: CGPoint) {
        view.layer.cornerRadius = view.bounds.size.height / 2.0
        view.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(
            arcCenter: CGPoint(x: view.bounds.height/2,
                               y: view.bounds.height/2),
            radius: view.bounds.height,
            startAngle: CGFloat(0),
            endAngle:CGFloat(CGFloat.pi * 1.5),
            clockwise: true).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        view.layer.addSublayer(gradient)
    }
    
    func showProcessing(animating: Bool = true) {
        processingView.animatePreloader = animating
        view.addSubview(processingView)
        
    }
    
    func hideProcessing() {
        processingView.removeFromSuperview()
    }
    
    
    deinit {
        debugPrint("CLEANED \(String(describing: self))")
    }
    
    func showBackButton() {
        navigationItem.hidesBackButton = true
        
        let newImage = UIImage.imageWithImage(image: UIImage.init(named: "backLighRed")!,
                                              scaledToSize: CGSize(width: 42,
                                                                   height: 42))
         backButton = UIBarButtonItem(image: newImage.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTap(_:)))
        backButton?.tintColor = UIColor.gray
        navigationItem.leftBarButtonItem = backButton
        self.backButton?.isEnabled = true
    }
    
    @objc func backTap (_ sender: UIButton) {
        self.back(with: .pop)
    }
    
    func hideBackButton() {
        self.backButton?.isEnabled = false
        self.backButton?.tintColor = UIColor.clear
        navigationItem.leftBarButtonItem = nil
    }
    
    
    func showAlertMessage(firstText: String,
                          secondText: String,
                          successButtonText: String = "Удалить",
                          buttonType: ButtonType = .twoButtons,
                          success: @escaping () -> Void,
                          cancel: @escaping () -> Void) {
        slide.height = 313
        slide.direction = .bottom
        let alertVC = NavigationController.init(rootViewController: AlertActionController(firstText: firstText, secondText: secondText, successButtonText: successButtonText, buttonType: buttonType, success: success, cancel: cancel))
        alertVC.transitioningDelegate = slide
        alertVC.modalPresentationStyle = .custom
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func wrapIntoNavigationController() -> NavigationController {
        let navController = NavigationController()
        navController.setViewControllers([self], animated: false)
        return navController
    }
    
    func back(with route: BackRoute, animated: Bool = true) {
        switch route {
        case .pop:
            self.navigationController?.popViewController(animated: animated)
        case .toOrigin:
            self.navigationController?.popToRootViewController(animated: animated)
        case .dismiss:
            self.dismiss(animated: animated, completion: nil)
        case .dismissAll:
            self.view.window?.rootViewController?.dismiss(animated: animated, completion: nil)
        case .toRoot:
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func twoLineTitleView(text: String, color: UIColor) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: UIScreen.main.bounds.width - 150,
                                          height: 40))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16 * RatioCoeff.width)
        label.textAlignment = .center
        label.textColor = color
        label.lineBreakMode = .byWordWrapping
        label.text = text
        return label
    }
    
    func perform(transition to: UIViewController) {
        self.navigationController?.pushViewController(to, animated: true)
        if to is SelectedCategoryViewController || to is SearchViewController {
            
        } else {
            self.tabBarController?.tabBar.isHidden = true
        }
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func present(transition to: UIViewController) {
        self.navigationController?.present(to, animated: true, completion: nil)
    }
    
    func share(text: String, link: String, data: Any? = nil) {
        if let myWebsite = NSURL(string: link.trimmed) {
            var objectsToShare: [Any]
            if let sendimage = data {
                objectsToShare = ["\(text)", "\n\(myWebsite)", sendimage]
            } else {
                objectsToShare = ["\(text)", "\n\(myWebsite)"]
            }
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: [])
            activityVC.popoverPresentationController?.sourceView = self.view
            DispatchQueue.main.async { [weak self] in
                self?.present(transition: activityVC)
            }
            
        }
    }
    
    
    
}

extension BaseViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

