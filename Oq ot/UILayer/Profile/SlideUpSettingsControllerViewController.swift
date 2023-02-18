//
//  SlideUpSettingsControllerViewController.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 26/07/22.
//

import UIKit


protocol ChangeLanguage: AnyObject {
    func changeLanguage(language: String)
}

class SlideUpSettingsController: BaseViewController {
    
    lazy var slideUpView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    var getText: String = ""
    
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.35
    
    weak var delegate: ChangeLanguage?
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = Theme.current.grayColor
        return view
    }()
    
    lazy var languageChooseLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(17, "chooseLanguage".translate(), false, Theme.current.blackColor, .center)
        return label
    }()
    
    lazy var button1: UIButton = {
        let b = UIButton()
        b.setTitle("Русский", for: .normal)
        b.layer.cornerRadius = 10
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = .white
        b.layer.borderWidth = 1.5
        b.layer.borderColor = Theme.current.borderOrangeColor.withAlphaComponent(0.3).cgColor
        b.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var button2: UIButton = {
        let b = UIButton()
        b.setTitle("O'zbek", for: .normal)
        b.layer.cornerRadius = 10
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = .white
        b.layer.borderWidth = 1.5
        b.layer.borderColor = Theme.current.borderOrangeColor.withAlphaComponent(0.3).cgColor
        b.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var button3: UIButton = {
        let b = UIButton()
        b.setTitle("English", for: .normal)
        b.layer.cornerRadius = 10
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = .white
        b.layer.borderWidth = 1.5
        b.layer.borderColor = Theme.current.borderOrangeColor.withAlphaComponent(0.3).cgColor
        b.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureSlideUp()
        for button in [button1, button2, button3] {
            if button.currentTitle ==  getText {
                button.layer.borderColor = Theme.current.gradientLabelColors[0]
            }
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        button1.layer.borderColor = Theme.current.borderOrangeColor.withAlphaComponent(0.3).cgColor
        button2.layer.borderColor = Theme.current.borderOrangeColor.withAlphaComponent(0.3).cgColor
        button3.layer.borderColor = Theme.current.borderOrangeColor.withAlphaComponent(0.3).cgColor
        sender.layer.borderColor = Theme.current.gradientLabelColors[0]
        delegate?.changeLanguage(language: sender.currentTitle ?? "")
        dismiss(animated: true)
    }
    
    private func configureSlideUp() {
        view.addSubview(slideUpView)
        slideUpView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: slideUpViewHeight))
        slideUpView.addSubview(topLine)
        topLine.anchor(top: slideUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 5))
        topLine.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        slideUpView.addSubview(languageChooseLabel)
        languageChooseLabel.anchor(top: topLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 15 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 20))
        slideUpView.addSubview(button1)
        button1.anchor(top: languageChooseLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 40 * RatioCoeff.height))
        slideUpView.addSubview(button2)
        button2.anchor(top: button1.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 40 * RatioCoeff.height))
        slideUpView.addSubview(button3)
        button3.anchor(top: button2.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 40 * RatioCoeff.height))
    }
}

