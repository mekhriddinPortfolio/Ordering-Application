//
//  BottomRecomendedCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 10/09/22.
//

import UIKit


class BottomRecomendedCell: UICollectionViewCell {
    
    var discountedGoodsModel: [EachDiscountedGood]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var didTapMore: (() -> Void)?
    var shouldReload: (() -> Void)?
    var didTapItem: ((_ model: EachDiscountedGood ) -> Void)?
    var isFavoritesCell = false
    var didEditCount: (() -> Void)?
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
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
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
        return l
    }()
  
    private func setupView() {
        
        addSubview(collectionView)
        addSubview(categoryName)
        categoryName.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        collectionView.anchor(top: categoryName.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 0), size: CGSize(width: self.frame.width, height: self.frame.height - 50))
    }
}


extension BottomRecomendedCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecomendationItemsCellProtocol {
    func reloadCollection(afterLike: Bool) {
        if isFavoritesCell && afterLike {
            self.shouldReload?()
        } else {
            self.didEditCount?()
            self.collectionView.reloadData()
        }

       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discountedGoodsModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsCell.self), for: indexPath) as! RecomendationItemsCell
        cell.delegate = self
        if let data = discountedGoodsModel?[indexPath.row] {
            cell.setItem(item: data, categoryName: "Рекомендуем")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - 52)/3, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let item = discountedGoodsModel?[indexPath.row] {
                didTapItem?(item)
            }
    }
}
