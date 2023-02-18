//
//  NotCompletedFuncViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 29/08/22.
//

import UIKit

class NotCompletedFuncViewController: BaseViewController {

    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.alpha = 0.15
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "thisFunction".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .center)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var imageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "notImplemented")
        return im
    }()
    
    lazy var backtoButton: BaseButton = {
        let l = BaseButton()
        l.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "return".translate(), false, .white), for: .normal)
        return l
    }()
    
    @objc func backButtonTapped() {
        print("backButtonTapped")
        self.back(with: .toOrigin)
        // gooo to sms to phone number screen....
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = twoLineTitleView(text: "vaucherAndPromo".translate(), color: UIColor.black)
        self.tabBarController?.tabBar.isHidden = false
        view.backgroundColor = .white
        backtoButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
        view.addSubview(backgroundImageView)
        let screenSize = UIScreen.main.bounds.size
        backgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: (screenSize.width - 50), height: (screenSize.width - 50) * 2 / 3))
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(backtoButton)
        imageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0), size: CGSize(width: 280*RatioCoeff.width, height: 250*RatioCoeff.height))
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 50))
        
        backtoButton.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 17, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 50 * RatioCoeff.height))
        backtoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
