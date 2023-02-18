//
//  MenuSlidingViewController.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 23/08/22.
//

import UIKit

class MenuSlidingViewController: BaseViewController{
   
    var categoryData: [EachCategoryWithGoods]? {
        didSet {
            self.itemsCollectionView.reloadData()
        }
    }
    
    var didSelectCategory: ((_ index: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let topView = Utils.getTopView(color: .lightGray)
        view.addSubview(topView)
        view.addSubview(itemsCollectionView)
        topView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemsCollectionView.anchor(top: topView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: SCREEN_SIZE.width, height: (SCREEN_SIZE.height * 0.5) - 60))
    }
    
    lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(MenuSlidingVIewControllerCell.self, forCellWithReuseIdentifier: String.init(describing: MenuSlidingVIewControllerCell.self))
        return collection
    }()
}

extension MenuSlidingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MenuSlidingVIewControllerCell.self), for: indexPath) as! MenuSlidingVIewControllerCell
        cell.label.text = categoryData?[indexPath.row].category.name
        cell.layer.addBorder(edge: .bottom, color: UIColor(hex: "#F2F2F2", alpha: 0.08), thickness: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        didSelectCategory?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemsCollectionView.frame.size.width, height: 45)
    }

}
