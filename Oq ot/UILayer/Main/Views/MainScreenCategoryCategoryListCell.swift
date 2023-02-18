//
//  MainScreenCategoryCategoryListCell.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 22/08/22.
//

import UIKit

class MainScreenCategoryCategoryListCell: UICollectionViewCell {
    var didTapCategory: ((_ catID: String) -> Void)?
    weak var delegate: CategoryProtocol?
    var categoryModel: CategoryModel? {
        didSet {
            collectionView.reloadData()
        }
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(CategoryViewCell.self, forCellWithReuseIdentifier: String.init(describing: CategoryViewCell.self))
        return collection
    }()
 
    private func setupView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    
}

extension MainScreenCategoryCategoryListCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryModel?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: CategoryViewCell.self), for: indexPath) as! CategoryViewCell
        if let data = categoryModel?.categories[indexPath.row] {
        cell.setData(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.size.width - (16 * 2) - 30)/4, height: ((self.frame.size.width - (16*2) - 30)/4) + 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapCategory?((categoryModel?.categories[indexPath.row].id)!)
    }
    
}
