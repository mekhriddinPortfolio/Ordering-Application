//
//  MainScreenBottomCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 21/08/22.
//

import UIKit
import CoreMIDI

class MainScreenBottomCell: UICollectionViewCell {
    
    var discountedGoodsModel: [EachDiscountedGood]? {
        didSet {
            centerInfoLabel.isHidden = true
            if isFavoritesCell {
                centerInfoLabel.isHidden = discountedGoodsModel?.isEmpty == false
            }
            collectionView.reloadData()
        }
    }
    var didTapMore: (() -> Void)?
    var shouldReload: (() -> Void)?
    var didTapItem: ((_ model: EachDiscountedGood ) -> Void)?
    var isFavoritesCell = false
    var didEditCount: (() -> Void)?
    var didTapCategoryName: (() -> Void)?
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
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isUserInteractionEnabled = true
        collection.isScrollEnabled = true
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(RecomendationItemsCell.self, forCellWithReuseIdentifier: String.init(describing: RecomendationItemsCell.self))
        collection.register(RecomendationItemsMoreCell.self, forCellWithReuseIdentifier: String.init(describing: RecomendationItemsMoreCell.self))
        return collection
    }()
    
    lazy var categoryName: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .black
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCategoryNamee)))
        return l
    }()
    
    lazy var centerInfoLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = .black
        l.text = "pleaseLikeItems".translate()
        return l
    }()
    
    @objc private func didTapCategoryNamee() {
        self.didTapCategoryName?()
    }
    
    
    private func setupView() {
        
        addSubview(collectionView)
        addSubview(categoryName)
        addSubview(centerInfoLabel)
        categoryName.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        collectionView.anchor(top: categoryName.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 0), size: CGSize(width: self.frame.width, height: self.frame.height - 50))
        centerInfoLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: SCREEN_SIZE.width - 40, height: self.frame.height * 0.5))
        centerInfoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        centerInfoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerInfoLabel.isHidden = true
    }
}


extension MainScreenBottomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecomendationItemsCellProtocol {
    func reloadCollection(afterLike: Bool) {
        if isFavoritesCell && afterLike {
            self.shouldReload?()
        } else {
            self.didEditCount?()
            self.collectionView.reloadData()
        }

       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discountedGoodsModel?.isEmpty == false  ? (discountedGoodsModel?.count ?? 0) + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < (discountedGoodsModel?.count ?? 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsCell.self), for: indexPath) as! RecomendationItemsCell
            cell.delegate = self
            if let data = discountedGoodsModel?[indexPath.row] {
                cell.setItem(item: data, categoryName: categoryName.text.notNullString)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsMoreCell.self), for: indexPath) as! RecomendationItemsMoreCell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < (discountedGoodsModel?.count ?? 0) {
            if let item = discountedGoodsModel?[indexPath.row] {
                didTapItem?(item)
            }
        } else {
            didTapMore?()
        }
        
    }
}

