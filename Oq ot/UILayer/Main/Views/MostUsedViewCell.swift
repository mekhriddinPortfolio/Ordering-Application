//
//  MostUsedViewCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 17/07/22.
//

import UIKit

class MostUsedViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.backgroundColor = .clear

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setData(data: EachCategory) {
        categoryName.attributedText = NSAttributedString.getAttrTextWith(15, data.name, false , UIColor(hex: "#000000", alpha: 0.7), .left, 0, 0, .byTruncatingTail)
//        categoryImage.image = UIImage.init(named: image)?.tint(with: Theme.current.imageTintColor)
    }
    
    lazy var categoryName: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        return l
    }()
    
    lazy var itemsInCategory: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(13, "231 \("products".translate())", false , UIColor(hex: "#000000", alpha: 0.4), .left)
        return l
    }()
    
    lazy var categoryImage: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage(named: "kitkat")
        im.backgroundColor = .clear
        return im
        
    }()
    
    private func setupView() {
        addSubview(categoryName)
        addSubview(itemsInCategory)
        addSubview(categoryImage)
        
        categoryImage.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        categoryImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        categoryName.anchor(top: nil, leading: categoryImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        categoryName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -((15/2) + 1)).isActive = true
        
        itemsInCategory.anchor(top: nil, leading: categoryImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        itemsInCategory.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: ((15/2) + 1)).isActive = true
        
    }

}
