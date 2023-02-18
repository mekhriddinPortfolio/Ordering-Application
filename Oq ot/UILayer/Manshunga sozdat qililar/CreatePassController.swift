//
//  CreatePasswordViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 05/07/22.
//

import UIKit

class CreatePassController: BaseViewController {
    
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    var phoneNumber: String = ""
    
    var isEyeOpen: Bool = true
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PasswordCreateImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(20, "createPassword".translate(), false, Theme.current.blackColor, .center)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "createPasswordInfo".translate(), false, Theme.current.grayLabelColor5, .center)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var grayLabel1: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "password".translate(), false, Theme.current.grayLabelColor3, .left)
        return label
    }()
    
    lazy var grayLabel2: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "repeatPassword".translate(), false, Theme.current.grayLabelColor3, .left)
        return label
    }()
    
    lazy var passwordNotMatch: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "", false, Theme.current.redColor, .left)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var openEyeButton1: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.setImage(UIImage.init(named: "openEye"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(openEyeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var openEyeButton2: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage.init(named: "openEye"), for: .normal)
        btn.addTarget(self, action: #selector(openEyeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var textField1 = CustomTextField(placeholder: "enterPassword".translate(), textAlignment: .left, text: nil)
    lazy var textField2 = CustomTextField(placeholder: "enterPassword".translate(), textAlignment: .left, text: nil)

    lazy var confirmButton: BaseButton = {
        let confirmButton = BaseButton(title: "confirmButton".translate(), size: 15)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return confirmButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTextFields()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
    }
    
    @objc private func adjustForKeyboard() {
        self.widthConstraint?.constant = self.view.frame.size.width/5
        self.heightConstraint?.constant = self.view.frame.size.width/5
        UIView.animate(withDuration: 2, delay: 0) {
            self.view.layoutIfNeeded()
        }
       
    }
    
    @objc private func adjustForHide() {
        self.widthConstraint?.constant = self.view.frame.size.width/2.5
        self.heightConstraint?.constant = self.view.frame.size.width/2.5
        UIView.animate(withDuration: 2, delay: 0) {
            self.view.layoutIfNeeded()
        }
       
    }
    @objc private func viewPressed() {
        view.endEditing(true)
    }
    
    private func configureTextFields() {
        for textField in [textField1, textField2] {
            textField.rightViewMode = .always
            textField.isSecureTextEntry = true
        }
        textField1.rightView = paddingRightIcon(openEyeButton1, 5)
        textField2.rightView = paddingRightIcon(openEyeButton2, 5)
    }
    
    
    private func paddingRightIcon(_ view: UIView, _ padding: CGFloat) -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.addSubview(view)
        contentView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 50 + padding, height: 50))
        view.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        return contentView
    }
    
    
    @objc private func openEyeButtonTapped() {
        if isEyeOpen {
            textField1.isSecureTextEntry = false
            textField2.isSecureTextEntry = false
            openEyeButton1.setImage(UIImage.init(named: "closedEye"), for: .normal)
            openEyeButton2.setImage(UIImage.init(named: "closedEye"), for: .normal)
            isEyeOpen = false
        } else {
            textField1.isSecureTextEntry = true
            textField2.isSecureTextEntry = true
            openEyeButton1.setImage(UIImage.init(named: "openEye"), for: .normal)
            openEyeButton2.setImage(UIImage.init(named: "openEye"), for: .normal)
            isEyeOpen = true
        }
    }
    
    @objc func confirmTapped() {
        guard textField1.text == textField2.text else {
            passwordNotMatch.attributedText = NSAttributedString.getAttrTextWith(14, "passwordDidNotMatch".translate(), false, Theme.current.redColor, .left)
            return
        }
        
        let vc = RegController()
        self.perform(transition: vc)
//        vc.createdPassword = textField1.text.notNullString
        vc.phoneNumber = phoneNumber
        print("Passwords are same")
    }
    
    private func configure() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(confirmButton)
        view.addSubview(grayLabel1)
        view.addSubview(grayLabel2)
        view.addSubview(passwordNotMatch)
        
        widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width/2.5)
       heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.size.width/2.5)
        imageView.addConstraint(widthConstraint!)
        imageView.addConstraint(heightConstraint!)
        
        imageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 70 * RatioCoeff.height , left: 0, bottom: 0, right: 0), size: CGSize(width: 165 * RatioCoeff.height, height: 180 * RatioCoeff.height))
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 36 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 18 * RatioCoeff.height))
        
        bodyLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 6 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 36 * RatioCoeff.height))
        
        textField1.anchor(top: bodyLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 36 * RatioCoeff.height, left: 31, bottom: 0, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        textField2.anchor(top: textField1.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 36 * RatioCoeff.height, left: 31, bottom: 0, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        passwordNotMatch.anchor(top: textField2.bottomAnchor, leading: textField2.leadingAnchor, bottom: nil, trailing: textField2.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 30 * RatioCoeff.height))
        
        confirmButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 70 * RatioCoeff.height, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        grayLabel1.anchor(top: nil, leading: textField1.leadingAnchor, bottom: textField1.topAnchor, trailing: textField1.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        grayLabel2.anchor(top: nil, leading: textField2.leadingAnchor, bottom: textField2.topAnchor, trailing: textField2.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
    }

}

