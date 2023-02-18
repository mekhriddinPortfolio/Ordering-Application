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
            pagingView.numberOfPages = Int((CGFloat(self.categoryModel?.categories.count ?? 0) / 8.0).rounded(.up))
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
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0
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
    
    lazy var pagingView: UIPageControl = {
        let p = UIPageControl()
        p.currentPageIndicatorTintColor = Theme.current.gradientColor1
        p.pageIndicatorTintColor = Theme.current.gradientColor1.withAlphaComponent(0.4)
        return p
    }()
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pagingView.currentPage = Int(pageNumber)
    }
 
    private func setupView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: -20, left: 10, bottom: 20, right: 10))
        addSubview(pagingView)
        pagingView.anchor(top: collectionView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 200 * RatioCoeff.width, height: 10))
        pagingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

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
        return CGSize(width: collectionView.frame.size.width/4, height: (collectionView.frame.size.height - 30)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapCategory?((categoryModel?.categories[indexPath.row].id)!)
    }
    
}
