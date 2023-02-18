//
//  MainTabbarController.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 25/02/22.
//

import UIKit

class MainTabbarController: UITabBarController, UITabBarControllerDelegate  {
    var mainVC: BasketController!
    var securityVC: MainViewController!
    var registeredProfileVC: ProfileViewController!
    var notRegisteredProfileVC: InitialProfileViewController!
    let imageV = UIImageView(image: UIImage.init(named: "tabHomeSelected"))
    let profileImage = UIImageView(image: UIImage.init(named: "tabUser"))
    let basketImage = UIImageView(image: UIImage.init(named: "tabBasket"))
    
    
    private var shapeLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        object_setClass(self.tabBar, BiggerTabBar.self)
        customiseTab()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 1
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.backgroundColor = .clear
        UITabBar.appearance().tintColor = UIColor.clear
        UITabBar.appearance().layer.cornerRadius = 30
        UITabBar.appearance().layer.borderColor = UIColor.white.cgColor
        UITabBar.appearance().layer.borderWidth = 1
        addTabBarShadowBG()
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = false
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        basketImage.image = basketImage.image?.withRenderingMode(.alwaysTemplate)
        profileImage.image = profileImage.image?.withRenderingMode(.alwaysTemplate)
        imageV.image = imageV.image?.withRenderingMode(.alwaysTemplate)
        self.profileImage.tintColor = .lightGray
        self.basketImage.tintColor = .lightGray
        self.imageV.tintColor = .lightGray
        switch item.tag {
        case 0:
            basketImage.image = basketImage.image?.withRenderingMode(.alwaysOriginal)
        case 1:
            imageV.image = imageV.image?.withRenderingMode(.alwaysOriginal)
        case 2:
            profileImage.image = profileImage.image?.withRenderingMode(.alwaysOriginal)
        default:
            break
        }
    }
    
    class BiggerTabBar: UITabBar {
           override func sizeThatFits(_ size: CGSize) -> CGSize {
               var sizeThatFits = super.sizeThatFits(size)
               sizeThatFits.height = 80 * RatioCoeff.height
               return sizeThatFits
           }
       }
    
    init(isRegistered: Bool) {
        super.init(nibName: nil, bundle: nil)
        initControllers(isRegistered: isRegistered)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTabBarShadowBG() {
        let tabBarCornerRadius: CGFloat = 30
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(
            roundedRect: tabBar.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: tabBarCornerRadius, height: 1.0)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: tabBarCornerRadius).cgPath
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOpacity = 0.8
        shapeLayer.shadowRadius = 4
        shapeLayer.borderWidth = 1
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shouldRasterize = true
        shapeLayer.rasterizationScale = UIScreen.main.scale

        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    
    private func customiseTab() {
        let blurView = UIView(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 80 * RatioCoeff.height))
        blurView.layer.cornerRadius = 30
        blurView.backgroundColor = .white
        let scanLayer = CAShapeLayer()
        let scanRect = CGRect.init(x: (tabBar.frame.width/2) - 35, y: tabBar.frame.height/2 - 35, width: 70, height:70)
        let outerPath = UIBezierPath(ovalIn: scanRect)
        let superlayerPath = UIBezierPath.init(rect: blurView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = CAShapeLayerFillRule.evenOdd
        scanLayer.fillColor = UIColor.black.cgColor
        blurView.layer.mask = scanLayer
        tabBar.insertSubview(blurView, at: 0)
        imageV.contentMode = .scaleAspectFit
//        imageV.tintColor = Theme.current.gradientColor2
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        tabBar.insertSubview(containerView, at: 0)
        containerView.frame = CGRect.init(x: (tabBar.frame.width/2) - 30, y: tabBar.frame.height/2 - 30, width: 60, height:60)
        containerView.addSubview(imageV)
        imageV.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 30, height: 30))
        imageV.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageV.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        tabBar.insertSubview(profileImage, aboveSubview: blurView)
        tabBar.insertSubview(basketImage, aboveSubview: blurView)
        profileImage.image = profileImage.image?.withRenderingMode(.alwaysTemplate)
        profileImage.tintColor = .lightGray
        profileImage.frame = CGRect.init(x: (tabBar.frame.width/2) + 60, y: tabBar.frame.height/2 - 15 , width: 25, height:25)
        basketImage.image = basketImage.image?.withRenderingMode(.alwaysTemplate)
        basketImage.tintColor = .lightGray
        basketImage.frame = CGRect.init(x: (tabBar.frame.width/2) - 88, y: tabBar.frame.height/2 - 15 , width: 25, height:25)
        
    }
    
    
    
    func initControllers(isRegistered: Bool) {
        mainVC = BasketController()
        securityVC = MainViewController()
        registeredProfileVC = ProfileViewController()
        notRegisteredProfileVC = InitialProfileViewController()
        let customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBasket")?.tint(with: .clear), selectedImage: UIImage(named: "tabBasket")?.tint(with: .clear))
        customTabBarItem.title = nil
        customTabBarItem.tag = 0

        let customTabBarItem2: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabBasket")?.tint(with: .clear), selectedImage: UIImage(named: "tabBasket")?.tint(with: .clear))
        customTabBarItem2.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        customTabBarItem2.title = nil
        customTabBarItem2.tag = 1
        let customTabBarItem3: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabUser")?.tint(with: .clear), selectedImage: UIImage(named: "tabUser")?.tint(with:  .red))
        customTabBarItem3.title = nil
        customTabBarItem3.tag = 2
        mainVC.tabBarItem = customTabBarItem
        securityVC.tabBarItem = customTabBarItem2
        let profileVC = isRegistered ? registeredProfileVC : notRegisteredProfileVC
        
        if let profileVC = profileVC {
            profileVC.tabBarItem = customTabBarItem3
            setViewControllers([mainVC.wrapIntoNavigationController(),
                                securityVC.wrapIntoNavigationController(),
                                profileVC.wrapIntoNavigationController(),
                               ], animated: false)
        }
        tabBar.tintColor =  UIColor.brown
        tabBar.unselectedItemTintColor =  UIColor.lightGray
      
    }
}






