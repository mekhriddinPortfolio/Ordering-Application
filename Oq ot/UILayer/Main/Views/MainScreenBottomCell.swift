//
//  MainScreenBottomCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 21/08/22.
//

import UIKit

class MainScreenBottomCell: UICollectionViewCell {
    
    var discountedGoodsModel: [EachDiscountedGood]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        return l
    }()
    
    
    private func setupView() {
        addSubview(collectionView)
        addSubview(categoryName)
        categoryName.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        collectionView.anchor(top: categoryName.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: self.frame.size)
    }
}


extension MainScreenBottomCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecomendationItemsCellProtocol {
    func reloadCollection() {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (discountedGoodsModel?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < (discountedGoodsModel?.count ?? 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsCell.self), for: indexPath) as! RecomendationItemsCell
            cell.delegate = self
            if let data = discountedGoodsModel?[indexPath.row] {
                cell.setItem(item: data)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsMoreCell.self), for: indexPath) as! RecomendationItemsMoreCell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 * RatioCoeff.width, height: 240)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}

