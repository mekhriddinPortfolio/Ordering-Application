//
//  MenuSlidingVIewControllerCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 23/08/22.
//

import UIKit

class MenuSlidingVIewControllerCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .center
        label.textColor = .black
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


