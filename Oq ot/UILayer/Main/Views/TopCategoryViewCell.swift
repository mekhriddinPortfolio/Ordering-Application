//
//  TopCategoryViewCell.swift
//  Oq ot
//
//  Created by AvazbekOS on 17/07/22.
//

import UIKit

class TopCategoryViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupView()
        bottomSeparatorView.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.bottomSeparatorView.isHidden = false
            } else {
                self.bottomSeparatorView.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItem(item: EachCategoryWithGoods) {
        nameLabel.text = item.category.name
    }
    
    lazy var bottomSeparatorView: GradiendView = {
        let v = GradiendView()
        v.backgroundColor = .red
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 1
        v.isHidden = true
        v.isUserInteractionEnabled = false
        return v
    }()
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    
    private func setupView() {
        addSubview(nameLabel)
        addSubview(bottomSeparatorView)
        
        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: 0, height: 15))
        bottomSeparatorView.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 3), size: CGSize(width: 0, height: 3.0))
        nameLabel.bringSubviewToFront(bottomSeparatorView)
    }
}
