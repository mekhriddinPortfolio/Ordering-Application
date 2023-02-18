//
//  ChooseImageSlideUp.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 24/09/22.
//

import UIKit


protocol ChooseImageProtocol: AnyObject {
    func chooseFromGalary()
    func openCam()
    func deletePhoto()
}

class ChooseImageSlideUp: BaseViewController {
    
    lazy var slideUpView: UIView = {
        let  view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    let separatorLine1: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.headlinesColor.withAlphaComponent(0.08)
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()
    
    let separatorLine2: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.headlinesColor.withAlphaComponent(0.08)
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()
    
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.3
    
    weak var delegate: ChooseImageProtocol?
    
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = Theme.current.grayColor
        return view
    }()
    
    lazy var chooseOneLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(17, "Выберите тип", false, Theme.current.blackColor.withAlphaComponent(0.8), .left)
        return label
    }()
    
    lazy var openCamLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "Открыть камеру", false, Theme.current.blackColor.withAlphaComponent(0.6), .left)
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.openCam(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)
        return label
    }()
    
    lazy var chooseFromGalaryLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "Выбрать из галереи", false, Theme.current.blackColor.withAlphaComponent(0.6), .left)
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.chooseFromGalary(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)
        return label
    }()
    
    lazy var deletePhotoLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "Удалить фотографию", false, Theme.current.blackColor.withAlphaComponent(0.6), .left)
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.deletePhoto(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        configureSlideUp()
    }
    
     
    @objc func chooseFromGalary(_ sender: UITapGestureRecognizer) {
        delegate?.chooseFromGalary()
    }

    @objc func openCam(_ sender: UITapGestureRecognizer) {
        delegate?.openCam()
    }
    
    @objc func deletePhoto(_ sender: UITapGestureRecognizer) {
        delegate?.deletePhoto()
    }
     
 
    private func configureSlideUp() {
        view.addSubview(slideUpView)
        
        slideUpView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: slideUpViewHeight))
        slideUpView.addSubview(topLine)
        
        topLine.anchor(top: slideUpView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 5))
        topLine.centerXAnchor.constraint(equalTo: slideUpView.centerXAnchor).isActive = true
        
        slideUpView.addSubview(chooseOneLabel)
        slideUpView.addSubview(openCamLabel)
        slideUpView.addSubview(chooseFromGalaryLabel)
        slideUpView.addSubview(deletePhotoLabel)
        slideUpView.addSubview(separatorLine1)
        slideUpView.addSubview(separatorLine2)
        
        chooseOneLabel.anchor(top: slideUpView.topAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 30 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 22))
        openCamLabel.anchor(top: chooseOneLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 30 * RatioCoeff.height))
        separatorLine1.anchor(top: openCamLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        chooseFromGalaryLabel.anchor(top: openCamLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 30 * RatioCoeff.height))
        separatorLine2.anchor(top: chooseFromGalaryLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        deletePhotoLabel.anchor(top: chooseFromGalaryLabel.bottomAnchor, leading: slideUpView.leadingAnchor, bottom: nil, trailing: slideUpView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 16), size: CGSize(width: 0, height: 30 * RatioCoeff.height))
    }
}

