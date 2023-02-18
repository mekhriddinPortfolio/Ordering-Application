//
//  RecomendationItemsMoreCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 16/08/22.
//

import UIKit

class RecomendationItemsMoreCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = UIColor(hex: "#F7F7F7")
//        let showMoreLabel = UILabel()
        let arrowImage = UIImageView()
        arrowImage.contentMode = .scaleAspectFit
        arrowImage.image = UIImage.init(named: "rightArrow")
//        showMoreLabel.textAlignment = .center
//        showMoreLabel.text = "Show more"
//        addSubview(showMoreLabel)
        addSubview(arrowImage)
        arrowImage.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 40, height: 40))
        arrowImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        showMoreLabel.anchor(top: arrowImage.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
