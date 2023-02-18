//
//  SearchViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 16/07/22.
//

import UIKit

class SearchViewController: BaseViewController {
    
    let searchView = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
    }
    
    
    var data: CategoryWithGoods? {
        didSet {
            self.collectionView.reloadData()
            self.navigationItem.title = data?.categories.first?.category.name
        }
    }
    
    var goodsModel: [EachDiscountedGood]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        return v
    }()
    
    
    lazy var resultsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.text = "resultsFromYourSearch".translate()
        l.textAlignment = .left
        l.textColor = UIColor(hex: "#7A7A7A", alpha: 0.7)
        l.font = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.separatorStyle = .none
        t.backgroundColor = .white
        t.alwaysBounceVertical = false
        t.bounces = false
        t.contentInset = UIEdgeInsets.zero
        t.showsVerticalScrollIndicator = false
        t.register(BasketCell.self, forCellReuseIdentifier: String.init(describing: BasketCell.self))
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collection.decelerationRate = .normal
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .lightGray
        collection.isScrollEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.isUserInteractionEnabled = true
        collection.register(TopCategoryViewCell.self, forCellWithReuseIdentifier: String.init(describing: TopCategoryViewCell.self))

        return collection
    }()
    
    private func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(resultsLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(collectionView)
        containerView.addSubview(searchView)
        
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 40 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        searchView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        collectionView.anchor(top: searchView.bottomAnchor, leading: searchView.leadingAnchor, bottom: nil, trailing: searchView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        resultsLabel.anchor(top: collectionView.bottomAnchor, leading: collectionView.leadingAnchor, bottom: nil, trailing: collectionView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 17))
        tableView.anchor(top: resultsLabel.bottomAnchor, leading: resultsLabel.leadingAnchor, bottom: containerView.bottomAnchor, trailing: resultsLabel.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: BasketCell.self), for: indexPath) as! BasketCell
        cell.selectionStyle = .none
        cell.infoView.isUserInteractionEnabled = true
        cell.infoView.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * RatioCoeff.height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: TopCategoryViewCell.self), for: indexPath) as! TopCategoryViewCell
        cell.setItem(item: data!.categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let textWidth = data?.categories[indexPath.item].category.name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) {
            return CGSize(width: textWidth, height: 25)
        }
        
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = InfoProductSlideUpViewController()
        vc.setData(model: goodsModel?[indexPath.row])
        self.present(transition: vc)
      
    }
}



