//
//  ProfileImageChangeView.swift
//  Oq ot
//
//  Created by AvazbekOS on 30/08/22.
//

import UIKit

class ProfileImageChangeView: UIView {

    var imagePicker = UIImagePickerController()
    
    lazy var uploadPhotoView: GradiendView = {
        let  view = GradiendView()
        view.gradientLayer.cornerRadius = 29 * RatioCoeff.height
        return view
    }()
    
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "upload")
        return imageView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var text: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(16, "profilePhoto".translate(), false, UIColor(hex: "#000000", alpha: 0.7), .left)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var desc: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "changeProfilePhoto".translate(), false, UIColor(hex: "#000000", alpha: 0.5), .left)
        l.numberOfLines = 0
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(uploadPhotoView)
        addSubview(text)
        addSubview(desc)
        uploadPhotoView.addSubview(uploadImageView)
        uploadPhotoView.addSubview(profileImageView)
        
        uploadPhotoView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 0), size: CGSize(width: 58 * RatioCoeff.height, height: 58 * RatioCoeff.height))
        uploadImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 30, height: 30))
        uploadImageView.centerXAnchor.constraint(equalTo: uploadPhotoView.centerXAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: uploadPhotoView.centerYAnchor).isActive = true
        
        profileImageView.frame = CGRect(x: 0, y: 0, width: 2 * 29 * RatioCoeff.height, height: 2 * 29 * RatioCoeff.height)
        profileImageView.layer.cornerRadius = 29 * RatioCoeff.height
        profileImageView.layer.masksToBounds = true
        
        text.anchor(top: uploadPhotoView.topAnchor, leading: uploadPhotoView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 13, left: 13, bottom: 0, right: 15), size: CGSize(width: 0, height: 20))
        desc.anchor(top: text.bottomAnchor, leading: text.leadingAnchor, bottom: bottomAnchor, trailing: text.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 0, bottom: 15, right: 50))
    }

}
