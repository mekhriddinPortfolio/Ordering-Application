//
//  AlertActionViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 25/08/22.
//

import UIKit

enum ButtonType {
    case twoButtons
    case oneButton
}

class AlertActionController: BaseViewController {
    var okFunction: (() -> Void)?
    var cancelFunction: (() -> Void)?
    
    var firstText = ""
    var secondText = ""
    var successButtonText = ""
    var buttonType: ButtonType = .twoButtons
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        setupView()
    }
    
    
    init(firstText: String,
         secondText: String,
         successButtonText: String,
         buttonType: ButtonType = .twoButtons,
         success: @escaping () -> Void,
         cancel: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.okFunction = success
        self.cancelFunction = cancel
        self.firstText = firstText
        self.secondText = secondText
        self.buttonType = buttonType
        self.successButtonText = successButtonText
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var confirmButton: BaseButton = {
        let btn = BaseButton()
        let title = buttonType == .oneButton ? "OK" : successButtonText
        btn.setAttributedTitle(NSAttributedString.getAttrTextWith(15, title, false, .white, .center), for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = Theme.current.redColor
        btn.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var refuseButton: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "Отменить", false, .gray, .center), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor(hex: "#FFA800").cgColor
        btn.layer.borderWidth = 1.0
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(refuseTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var questionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.attributedText = NSAttributedString.getAttrTextWith(17, firstText, false, .black, .center)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.attributedText = NSAttributedString.getAttrTextWith(15, secondText, false, .gray, .center)
        return lbl
    }()
    
    let separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.separatorViewBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()
    
    
    @objc private func refuseTapped() {
        cancelFunction?()
    }
    
    @objc private func confirmTapped() {
        okFunction?()
    }
    
    
    func setupView() {
        view.addSubview(questionLabel)
        view.addSubview(separatorLine)
        view.addSubview(descriptionLabel)
        view.addSubview(confirmButton)
        
        let topView = Utils.getTopView(color: .lightGray)
        view.addSubview(topView)
        topView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.anchor(top: topView.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        // 60+
        separatorLine.anchor(top: questionLabel.bottomAnchor, leading: questionLabel.leadingAnchor, bottom: nil, trailing: questionLabel.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        //16+
        descriptionLabel.anchor(top: separatorLine.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 40))
        // 50+
        if buttonType != .oneButton {
        view.addSubview(refuseButton)
        refuseButton.anchor(top: descriptionLabel.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        }
        confirmButton.anchor(top: descriptionLabel.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 81, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        // 137+
        // heigh of this view is 263 + 50 ( 50 is bottom constraints) = 313
    }
}
