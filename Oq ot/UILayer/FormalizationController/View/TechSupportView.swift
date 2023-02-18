//
//  TechSupportView.swift
//  Oq ot
//
//  Created by AvazbekOS on 04/08/22.
//

import UIKit

class TechSupportViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 1)
        view.layer.cornerRadius = 20
        view.setStyleWithShadow(cornerRadius: 20)
    }
    
    @objc func phoneButtonTapped() {
        Utils.callNumber(phoneNumber: "+998909311978")
    }
    @objc func chatButtonTapped() {
       
    }
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.separatorLineBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var techSupportlabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "appeal".translate(), false, UIColor(hex: "#7A7A7A"), .center)
        
        return l
    }()
    
    
    lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "techHelp".translate(), false, UIColor(hex: "#000000", alpha: 0.5), .center)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var phoneTechButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "call1".translate(), false, UIColor.white), for: .normal)
        l.contentHorizontalAlignment = .center
        l.backgroundColor = .white
        l.layer.borderColor = UIColor(hex: "#D3D3D3").cgColor
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        return l
    }()
    
    lazy var chatTechButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "call2".translate(), false, UIColor.white), for: .normal)
        l.contentHorizontalAlignment = .center
        l.backgroundColor = .white
        l.layer.borderColor = UIColor(hex: "#D3D3D3").cgColor
        l.layer.cornerRadius = 10
        l.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        return l
    }()
    
    private func setupView() {
        let separatorLine = Utils.getTopView(color: .lightGray)
        view.addSubview(separatorView)
        view.addSubview(techSupportlabel)
        view.addSubview(separatorLine)
        view.addSubview(descriptionLabel)
        view.addSubview(phoneTechButton)
        view.addSubview(chatTechButton)
        
        separatorView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        techSupportlabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        // 60+
        separatorLine.anchor(top: techSupportlabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        // 16+
        descriptionLabel.anchor(top: separatorLine.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 35))
        // 50+
        phoneTechButton.anchor(top: descriptionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        chatTechButton.anchor(top: phoneTechButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        // 187+
        // 315
    }
    

}
