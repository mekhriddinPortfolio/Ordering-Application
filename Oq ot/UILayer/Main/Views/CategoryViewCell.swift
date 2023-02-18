//
//  CategoryViewCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 14/07/22.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
           imageView.image = nil
       }
    
    func setData(data: EachCategory) {
        nameLabel.attributedText = NSAttributedString.getAttrTextWith(13, data.name, false, UIColor(hex:  "#000000", alpha: 0.4), .center, 0, 0, .byCharWrapping)
        if let url = URL(string: data.imageUrl ?? "") {
            imageView.kf.setImage(with: url)
        }
    }
    
    lazy var imageBackView: UIView = {
        let v = UIView()
        v.layer.masksToBounds = false
        v.layer.cornerRadius = self.frame.size.width/2
        v.backgroundColor = UIColor(hex: "#F7F7F7")
        return v
    }()
    
    lazy var backView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var imageView: UIImageView = {
        let im = UIImageView()
        im.backgroundColor = .clear
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()
    
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(imageBackView)
        imageBackView.addSubview(imageView)
        
        backView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        nameLabel.anchor(top: nil, leading: backView.leadingAnchor, bottom: backView.bottomAnchor, trailing: backView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        imageBackView.anchor(top: backView.topAnchor, leading: backView.leadingAnchor, bottom: nil, trailing: backView.trailingAnchor, size: CGSize(width: self.frame.size.width - 15, height: self.frame.size.width - 15))
        imageBackView.layer.cornerRadius = (self.frame.size.width - 15)/2
        imageView.anchor(top: imageBackView.topAnchor, leading: imageBackView.leadingAnchor, bottom: imageBackView.bottomAnchor, trailing: imageBackView.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    }
    
}
