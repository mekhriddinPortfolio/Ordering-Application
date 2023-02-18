//
//  SettingsViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 12/07/22.
//

import UIKit

class SettingsViewController: BaseViewController, ChangeLanguage {
    
    var model: ProfileInfoModel?
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.alpha = 0.15
        return imageView
    }()
    
    lazy var myView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var profileChangeView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var profileChangeImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "tabUser")?.tint(with: UIColor.black)
        return img
    }()
    
    lazy var profileChangeLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    lazy var rightImageView0: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "right-arrow 3")
        return img
    }()
    
    lazy var separatorView0: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var switchView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var switchImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "mode")
        return img
    }()
    
    lazy var switchDarkMode: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        return mySwitch
    }()
    
    lazy var switchLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "darkMode".translate(), false, Theme.current.blackColor, .left)
        return l
    }()
    
    lazy var separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var languageView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var languageImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "globe")
        return img
    }()
    
    lazy var languageLabel2: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "language".translate(), false, Theme.current.blackColor, .left)
        return l
    }()
    
    lazy var languageLabel1: GradientLabel = {
        let lbl = GradientLabel()
        lbl.attributedText = NSAttributedString.getAttrTextWith(14, "Русский", false)
        lbl.gradientColors = Theme.current.gradientLabelColors
        return lbl
    }()
    
    lazy var gradientUnderlineView: GradiendView = {
        let gradientUnderlineView = GradiendView()
        gradientUnderlineView.color1 = Theme.current.gradientColor1.withAlphaComponent(0.3).cgColor
        gradientUnderlineView.color2 = Theme.current.gradientColor2.withAlphaComponent(0.3).cgColor
        return gradientUnderlineView
    }()
    
    lazy var separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var notificationImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "notification")
        return img
    }()
    
    lazy var notificationLabel1: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "notificationSettings".translate(), false, Theme.current.blackColor, .left)
        return l
    }()
    
    lazy var rightImageView1: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "right-arrow 3")
        return img
    }()
    
    lazy var separatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var geolocationView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var geolocationImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "location2")
        return img
    }()
    
    lazy var geolocationLabel1: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "locationSettings".translate(), false, Theme.current.blackColor, .left)
        return l
    }()
    
    lazy var rightImageView2: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "right-arrow 3")
        return img
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(languageViewTapped))
        languageView.addGestureRecognizer(tap)
        profileChangeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileChange)))
        notificationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSettingsTapped)))
        geolocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSettingsTapped)))
        
        switch LanguageMngr.getAppLang() {
        case .Russian:
            languageLabel1.text = "Русский"
        case .Uzbek:
            languageLabel1.text = "O'zbek"
        case .English:
            languageLabel1.text = "English"
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UD.token != nil {
            print("Test 1 passed")
            profileChangeLabel.attributedText = NSAttributedString.getAttrTextWith(15, "changeData".translate(), false, Theme.current.blackColor, .left)
            profileChangeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileChange)))
        } else {
            profileChangeLabel.attributedText = NSAttributedString.getAttrTextWith(15, "Создать профиль", false, Theme.current.blackColor, .left)
            profileChangeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfileCreate)))
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = switchDarkMode.isOn
        if value {
            self.showAlertMessage(firstText: "error".translate(), secondText: "darkModeNotAvailable".translate(), buttonType: .oneButton) {
                self.dismiss(animated: true)
            } cancel: {
                self.dismiss(animated: true)
            }
            switchDarkMode.isOn = false
        }
    }
    
    private func configureConstraints() {
        self.navigationItem.titleView = twoLineTitleView(text: "settings".translate(), color: UIColor.black)
        self.tabBarController?.tabBar.isHidden = false
        view.addSubview(backgroundImageView)
        let screenSize = UIScreen.main.bounds.size
        backgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: (screenSize.width - 50), height: (screenSize.width - 50) * 2 / 3))
        view.addSubview(myView)
        myView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 120, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 305))
        
        view.addSubview(profileChangeView)
        profileChangeView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 120, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 60))
        profileChangeView.addSubview(profileChangeImageView)
        profileChangeImageView.anchor(top: profileChangeView.topAnchor, leading: profileChangeView.leadingAnchor, bottom: profileChangeView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 0), size: CGSize(width: 24, height: 24))
        profileChangeView.addSubview(rightImageView0)
        rightImageView0.anchor(top: nil, leading: nil, bottom: nil, trailing: profileChangeView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 14, height: 14))
        rightImageView0.centerYAnchor.constraint(equalTo: profileChangeImageView.centerYAnchor).isActive = true
        profileChangeView.addSubview(profileChangeLabel)
        profileChangeLabel.anchor(top: nil, leading: profileChangeImageView.trailingAnchor, bottom: nil, trailing: rightImageView0.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20), size: CGSize(width: 0, height: 22))
        profileChangeLabel.centerYAnchor.constraint(equalTo: profileChangeImageView.centerYAnchor).isActive = true
        myView.addSubview(separatorView0)
        separatorView0.anchor(top: profileChangeView.bottomAnchor, leading: myView.leadingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))

        
        view.addSubview(switchView)
        switchView.anchor(top: separatorView0.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 60))
        switchView.addSubview(switchImageView)
        switchImageView.anchor(top: switchView.topAnchor, leading: switchView.leadingAnchor, bottom: switchView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 0), size: CGSize(width: 24, height: 24))
        switchView.addSubview(switchDarkMode)
        switchDarkMode.anchor(top: nil, leading: nil, bottom: nil, trailing: switchView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60), size: CGSize(width: 20, height: 20))
        switchDarkMode.centerYAnchor.constraint(equalTo: switchImageView.centerYAnchor, constant: -3).isActive = true
        switchView.addSubview(switchLabel)
        switchLabel.anchor(top: nil, leading: switchImageView.trailingAnchor, bottom: nil, trailing: switchDarkMode.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20), size: CGSize(width: 0, height: 22))
        switchLabel.centerYAnchor.constraint(equalTo: switchImageView.centerYAnchor).isActive = true
        myView.addSubview(separatorView1)
        separatorView1.anchor(top: switchView.bottomAnchor, leading: myView.leadingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))
        
        view.addSubview(languageView)
        languageView.anchor(top: separatorView1.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 60))
        languageView.addSubview(languageImageView)
        languageImageView.anchor(top: languageView.topAnchor, leading: languageView.leadingAnchor, bottom: languageView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 0), size: CGSize(width: 24, height: 24))
        languageView.addSubview(languageLabel1)
        languageLabel1.anchor(top: nil, leading: nil, bottom: nil, trailing: languageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 60, height: 22))
        languageLabel1.centerYAnchor.constraint(equalTo: languageImageView.centerYAnchor).isActive = true
        languageView.addSubview(gradientUnderlineView)
        gradientUnderlineView.anchor(top: languageLabel1.bottomAnchor, leading: languageLabel1.leadingAnchor, bottom: nil, trailing: languageLabel1.trailingAnchor, padding: UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0), size: CGSize(width: (languageLabel1.text?.widthOfString(usingFont: languageLabel1.font))!, height: 1))
        gradientUnderlineView.centerXAnchor.constraint(equalTo: languageLabel1.centerXAnchor).isActive = true
        languageView.addSubview(languageLabel2)
        languageLabel2.anchor(top: nil, leading: languageImageView.trailingAnchor, bottom: nil, trailing: languageLabel1.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20), size: CGSize(width: 0, height: 22))
        languageLabel2.centerYAnchor.constraint(equalTo: languageImageView.centerYAnchor).isActive = true
        myView.addSubview(separatorView2)
        separatorView2.anchor(top: languageView.bottomAnchor, leading: myView.leadingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))
        
        view.addSubview(notificationView)
        notificationView.anchor(top: separatorView2.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 60))
        notificationView.addSubview(notificationImageView)
        notificationImageView.anchor(top: notificationView.topAnchor, leading: notificationView.leadingAnchor, bottom: notificationView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 0), size: CGSize(width: 24, height: 24))
        notificationView.addSubview(rightImageView1)
        rightImageView1.anchor(top: nil, leading: nil, bottom: nil, trailing: languageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 14, height: 14))
        rightImageView1.centerYAnchor.constraint(equalTo: notificationImageView.centerYAnchor).isActive = true
        notificationView.addSubview(notificationLabel1)
        notificationLabel1.anchor(top: nil, leading: notificationImageView.trailingAnchor, bottom: nil, trailing: rightImageView1.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20), size: CGSize(width: 0, height: 22))
        notificationLabel1.centerYAnchor.constraint(equalTo: rightImageView1.centerYAnchor).isActive = true
        myView.addSubview(separatorView3)
        separatorView3.anchor(top: notificationView.bottomAnchor, leading: myView.leadingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))
        
        view.addSubview(geolocationView)
        geolocationView.anchor(top: separatorView3.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 60))
        geolocationView.addSubview(geolocationImageView)
        geolocationImageView.anchor(top: geolocationView.topAnchor, leading: geolocationView.leadingAnchor, bottom: geolocationView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 0), size: CGSize(width: 24, height: 24))
        geolocationView.addSubview(rightImageView2)
        rightImageView2.anchor(top: nil, leading: nil, bottom: nil, trailing: geolocationView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 14, height: 14))
        rightImageView2.centerYAnchor.constraint(equalTo: geolocationImageView.centerYAnchor).isActive = true
        geolocationView.addSubview(geolocationLabel1)
        geolocationLabel1.anchor(top: nil, leading: geolocationImageView.trailingAnchor, bottom: nil, trailing: rightImageView2.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20), size: CGSize(width: 0, height: 22))
        geolocationLabel1.centerYAnchor.constraint(equalTo: rightImageView2.centerYAnchor).isActive = true
        
    }
                                               
    @objc func didTapProfileChange() {
            print("Test 2 passed")
            let vc = RegController(isProfileEditing: true, updateModel: model)
            self.perform(transition: vc)
    }
    @objc func didTapProfileCreate() {
            print("HERE IS ME")
            self.perform(transition: LoginPhoneNumController())
    }
    
    @objc func languageViewTapped() {
        let slide = SlideInPresentationManager()
        let slideUpView = SlideUpSettingsController()
        slideUpView.delegate = self
        slide.direction = .bottom
        slide.height = slideUpView.slideUpViewHeight
        slideUpView.getText = languageLabel1.text ?? ""
        let vc = NavigationController.init(rootViewController: slideUpView)
        vc.transitioningDelegate = slide
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    func changeLanguage(language: String) {
        languageLabel1.text = language
        switch language {
        case "Русский":
            LanguageMngr.setApplLang(.Russian)
        case "English":
            LanguageMngr.setApplLang(.English)
        case "O'zbek":
            LanguageMngr.setApplLang(.Uzbek)
        default:
            break
        }
        AppDelegate.shared?.setRoot(viewController: MainTabbarController(isRegistered: UD.token != nil))
    }
    
    @objc func didSettingsTapped() {
        print("HERE IS ME")
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    
    
}
