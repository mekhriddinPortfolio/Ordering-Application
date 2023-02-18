//
//  YandexMapPickupView.swift
//  Oq ot
//
//  Created by AvazbekOS on 26/07/22.
//

import UIKit

class YandexMapPickupView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        
        collection.isScrollEnabled = true
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.register(YandexAddressesViewCell.self, forCellWithReuseIdentifier: String(describing: YandexAddressesViewCell.self))
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    private func setupView() {
        addSubview(topView)
        addSubview(topLabel)
        addSubview(collectionView)
        
        topView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        topView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        topLabel.anchor(top: topView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 20))
        topLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        collectionView.anchor(top: topLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 40, right: 16))
        
    }
    
    lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 2
        return v
    }()
    
    lazy var topLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(20, "selectItem".translate(), false, .black)
        return l
    }()

}
