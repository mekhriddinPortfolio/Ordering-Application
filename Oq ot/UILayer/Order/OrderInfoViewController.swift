//
//  OrderInfoViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 11/07/22.
//

import UIKit

class OrderSlideUpViewController: BaseViewController {
    
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.35
    
    let saveButton = BaseButton(title: "Отследить", size: 15)
    let statusView = OrderStatusView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.current.slideUpViewBackColor
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: UIScreen.main.bounds.width * 1.175))
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        configure()
        Utils.delay(seconds: 1) {
            self.statusView.animateLine(percent: 0.4)
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "OrderSuccess")
        return imageView
    }()

    
    lazy var slideUpView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13 * RatioCoeff.height)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Заказ успешно оформлен! №384135"
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Осталось дождаться доставки в течении 30 мин. Вы можете отследить вашу доставку прямо из приложения. Тип оплаты - картой."
        label.font = UIFont.systemFont(ofSize: 11 * RatioCoeff.height)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.avatarLineSeparatorColor
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = Theme.current.grayColor
        return view
    }()
    
    lazy var skipButton: UIButton = {
        let b = UIButton()
        b.setTitle("Продолжить покупки", for: .normal)
        b.layer.cornerRadius = 8
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = .white
        b.layer.borderWidth = 1
        b.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        b.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15 * RatioCoeff.width)
        return b
    }()
    
    @objc func skipButtonTapped() {
        self.back(with: .toOrigin)
    }
    
    
    
    @objc func saveButtonTapped() {
        self.back(with: .toOrigin)
    }
    
    private func configure() {
        
        view.addSubview(slideUpView)
        slideUpView.addSubview(topLine)
        slideUpView.addSubview(titleLabel)
        slideUpView.addSubview(separatorLine)
        slideUpView.addSubview(bodyLabel)
        view.addSubview(skipButton)
        view.addSubview(saveButton)
        view.addSubview(statusView)
        
        slideUpView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: UIScreen.main.bounds.size.height / 2))
        topLine.anchor(top: slideUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 4))
        topLine.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        titleLabel.anchor(top: topLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 14 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 17 * RatioCoeff.height))
        separatorLine.anchor(top: titleLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        bodyLabel.anchor(top: separatorLine.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50 * RatioCoeff.height))
        
        saveButton.anchor(top: nil, leading: slideUpView.leadingAnchor, bottom: slideUpView.bottomAnchor, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 32 * RatioCoeff.height, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        skipButton.anchor(top: nil, leading: slideUpView.leadingAnchor, bottom: saveButton.topAnchor, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 5, right: 31), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        statusView.anchor(top: bodyLabel.bottomAnchor, leading: bodyLabel.leadingAnchor, bottom: nil, trailing: bodyLabel.trailingAnchor,  padding: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0), size: CGSize(width: 0, height: 50))
       
        
    }
    
}
