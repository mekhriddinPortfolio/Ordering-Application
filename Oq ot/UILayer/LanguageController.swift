//
//  LanguageController.swift
//  LanguagePart
//
//  Created by AvazbekOS on 04/07/22.
//

import UIKit

class LanguageController: BaseViewController {
    
    var preChoosenLanguageTAG: Int? = nil
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 50 * RatioCoeff.height, height: 50 * RatioCoeff.height)
    }
    
    lazy var imageGlobeView: UIImageView = {
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFit
        iV.image = UIImage(named: "LanGlobe")
        return iV
    }()
    
    lazy var descLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "chooseLanguage".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .center)
        return l
    }()
    
    lazy var russianButton: LanguageButton = {
        let btn = LanguageButton(title: "Русский", fontSize: 17)
        btn.addTarget(self, action: #selector(didTapButtons), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    lazy var uzbekButton: LanguageButton = {
        let btn = LanguageButton(title: "O'zbek", fontSize: 17)
        btn.addTarget(self, action: #selector(didTapButtons), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var englishButton: LanguageButton = {
        let btn = LanguageButton(title: "English", fontSize: 17)
        btn.addTarget(self, action: #selector(didTapButtons), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
//        st.alignment = .leading
        st.distribution = .fillEqually
        st.spacing = 5
        return st
    }()
    
    let nextView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.grayBackgraoundColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(hex: "#E8ECF4").cgColor
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var nextImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "disclosureIndicator")?.tint(with: UIColor(hex: "#000000", alpha: 1.0))
        return img
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 8
        return l
    }()
    
    @objc func nextViewTapped() {
        UD.didChooseLanguage = true
        AppDelegate.shared?.setRoot(viewController: MainTabbarController(isRegistered: false))
    }
    
    @objc func didTapButtons(_ sender: LanguageButton) {
        switch sender.tag {
        case 0:
            LanguageMngr.setApplLang(Language.Russian)
        case 1:
            LanguageMngr.setApplLang(Language.Uzbek)
        case 2:
            LanguageMngr.setApplLang(Language.English)
        default:
            break
        }
        if preChoosenLanguageTAG != nil {
            if preChoosenLanguageTAG != sender.tag {
                clearChangeUI()
            }
        } else {
            nextView.layer.insertSublayer(gradientLayer, at: 0)
            nextView.layer.borderWidth = 0.0
            nextImageView.image = UIImage(named: "disclosureIndicator")?.tint(with: UIColor(hex: "#FFFFFF", alpha: 1.0))
        }
        preChoosenLanguageTAG = sender.tag
        didLanguageChanged()
    }
    
    
    func didLanguageChanged() {
        switch LanguageMngr.getAppLang() {
        case .Russian:
            russianButton.layer.borderWidth = 1.5
            russianButton.layer.borderColor = UIColor(hex: "#FF4000", alpha: 1.0).cgColor
            russianButton.setAttributedTitle(NSAttributedString.getAttrTextWith(17, "Русский", false, UIColor(hex: "#000000", alpha: 0.7)), for: .normal)
        case .Uzbek:
            uzbekButton.layer.borderWidth = 1.5
            uzbekButton.layer.borderColor = UIColor(hex: "#FF4000", alpha: 1.0).cgColor
            uzbekButton.setAttributedTitle(NSAttributedString.getAttrTextWith(17, "O'zbek", false, UIColor(hex: "#000000", alpha: 0.7)), for: .normal)
        case .English:
            englishButton.layer.borderWidth = 1.5
            englishButton.layer.borderColor = UIColor(hex: "#FF4000", alpha: 1.0).cgColor
            englishButton.setAttributedTitle(NSAttributedString.getAttrTextWith(17, "English", false, UIColor(hex: "#000000", alpha: 0.7)), for: .normal)
        default:
            break
        }
    }
    
    private func clearChangeUI() {
        switch preChoosenLanguageTAG {
        case 0:
            russianButton.layer.borderWidth = 1.0
            russianButton.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.3).cgColor
            russianButton.setAttributedTitle(NSAttributedString.getAttrTextWith(17, "Русский", false, UIColor(hex: "#000000", alpha: 0.5)), for: .normal)
        case 1:
            uzbekButton.layer.borderWidth = 1.0
            uzbekButton.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.3).cgColor
            uzbekButton.setAttributedTitle(NSAttributedString.getAttrTextWith(17, "O'zbek", false, UIColor(hex: "#000000", alpha: 0.5)), for: .normal)
        case 2:
            englishButton.layer.borderWidth = 1.0
            englishButton.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.3).cgColor
            englishButton.setAttributedTitle(NSAttributedString.getAttrTextWith(17, "English", false, UIColor(hex: "#000000", alpha: 0.5)), for: .normal)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if language's already choosen in Profile screen logic have to be written with LangaugeManager
        setupView()
        nextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextViewTapped)))
    } // End of viewDidLoad
    
    func setupView() {
        view.addSubview(imageGlobeView)
        imageGlobeView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 100*RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 200*RatioCoeff.height, height: 190*RatioCoeff.height))
        imageGlobeView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(10*RatioCoeff.height)).isActive = true
        
        view.addSubview(descLabel)
        descLabel.anchor(top: imageGlobeView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 55*RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 20))
        
//        view.addSubview(russianButton)
//        russianButton.anchor(top: descLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: view.frame.width*0.90, height: RatioCoeff.width*60))
//        russianButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        view.addSubview(uzbekButton)
//        uzbekButton.anchor(top: russianButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: view.frame.width*0.90, height: RatioCoeff.width*60))
//        uzbekButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//
//        view.addSubview(englishButton)
//        englishButton.anchor(top: uzbekButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: view.frame.width*0.90, height: RatioCoeff.width*60))
//        englishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nextView)
        nextView.addSubview(nextImageView)
        nextView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), size: CGSize(width: 50 * RatioCoeff.height, height: 50 * RatioCoeff.height))
        nextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nextImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 11, height: 18))
        nextImageView.centerXAnchor.constraint(equalTo: nextView.centerXAnchor).isActive = true
        nextImageView.centerYAnchor.constraint(equalTo: nextView.centerYAnchor).isActive = true
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(russianButton)
        stackView.addArrangedSubview(uzbekButton)
        stackView.addArrangedSubview(englishButton)
        stackView.anchor(top: descLabel.bottomAnchor, leading: nil, bottom: nextView.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 15*RatioCoeff.height, left: 0, bottom: 10*RatioCoeff.height, right: 0),size: CGSize(width: SCREEN_SIZE.width*0.90, height: 0))
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
}

class LanguageButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    init(title: String = "" , fontSize: CGFloat = 17) {
        super.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString.getAttrTextWith(fontSize, title, false, UIColor(hex: "#000000", alpha: 0.5)), for: .normal)
        self.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.3).cgColor
        self.layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
