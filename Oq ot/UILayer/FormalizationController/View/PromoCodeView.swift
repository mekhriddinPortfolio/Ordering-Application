//
//  PromoCodeViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 28/07/22.
//

import UIKit


class PromoCodeViewController: BaseViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1)
        view.layer.cornerRadius = 20
        view.setStyleWithShadow(cornerRadius: 20)
    }
    
    @objc func confirmButtonTapped() {

    }
    @objc func cancelButtonTapped() {
    
    }
    
    @objc func textFieldDidChange() {
        if !promoTextfield.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "next".translate(), true, .red), for: .normal)
            confirmButton.isEnabled = true
        } else {
            confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(18, "next".translate(), true, Theme.current.blackColor.withAlphaComponent(0.4)), for: .normal)
            confirmButton.isEnabled = false
        }
        
    }
  
    
    lazy var promoCodelabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "enterPromoVaucher".translate(), false, UIColor(hex: "#7A7A7A"), .center)
        return l
    }()
    
    lazy var promoTextfield: LoginTextField = {
        let l = LoginTextField()
        l.delegate = self
        l.textColor = Theme.current.blackColor.withAlphaComponent(0.4)
        l.keyboardType = .default
        l.layer.masksToBounds = false
        l.layer.cornerRadius = 10
        l.layer.borderColor = Theme.current.gradientLabelColors[0]
        l.layer.borderWidth = 1.0
        l.backgroundColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 14)
        l.attributedPlaceholder = NSAttributedString.getAttrTextWith(14, "enterpromoCode".translate(), false, Theme.current.blackColor.withAlphaComponent(0.4), .left)
        l.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return l
    }()
    
    lazy var confirmButton: BaseButton = {
        let l = BaseButton()
        l.isEnabled = false
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "done".translate(), false, UIColor.white), for: .normal)
        l.contentHorizontalAlignment = .center
        l.backgroundColor = .white
        l.layer.borderColor = UIColor(hex: "#D3D3D3").cgColor
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return l
    }()
    
    lazy var cancelButton: UIButton = {
        let l = UIButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "cancel".translate(), false, UIColor(hex: "#828282")), for: .normal)
        l.contentHorizontalAlignment = .center
        l.backgroundColor = .white
        l.layer.borderColor = UIColor(hex: "#D3D3D3").cgColor
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return l
    }()
    
    private func setupView() {
        let separatorView = Utils.getTopView(color: .lightGray)
        view.addSubview(separatorView)
        view.addSubview(promoCodelabel)
        view.addSubview(promoTextfield)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        
        separatorView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promoCodelabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        // 60+
        promoTextfield.anchor(top: promoCodelabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        // 71+
        confirmButton.anchor(top: promoTextfield.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        cancelButton.anchor(top: confirmButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        // 132+
        // heigh of this view = 263 + 50 ( 50 is bottom constraints) = 313
    }

}
