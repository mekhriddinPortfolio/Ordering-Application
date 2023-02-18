//
//  TopCategoryView.swift
//  Oq ot
//
//  Created by AvazbekOS on 17/07/22.
//

import UIKit

protocol CategoryProtocol: AnyObject {
    func openDetailedInfo(model: EachDiscountedGood?)
}

class SelectedCategoryViewController: BaseViewController {
    
    weak var delegate: CategoryProtocol?
    let viewModel = MainScreenViewModel()
    let searchView = SearchView()
    let slidingController = MenuSlidingVIewController()
    private let slide = SlideInPresentationManager()
    var data: CategoryWithGoods? {
        didSet {
            collectionView.reloadData()
            self.navigationItem.title = data?.categories.first?.category.name
        }
    }
    
    var goodsModel: [EachDiscountedGood]? {
        didSet {
            itemsCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .clear
        Utils.delay(seconds: 0.3) {
            if let firstCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? TopCategoryViewCell {
                firstCell.isSelected = true
                let allData =  self.data?.categories.map {$0.goods}.flatMap { $0 }
                self.goodsModel = allData
            }
            
        }
        
        slidingController.didSelectCategory = { [weak self] index in
            guard let self = self else {return}
            self.selectCell(indexPath: IndexPath(row: index, section: 0))
        }
    }
    
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        return v
    }()
  
    lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(RecomendationItemsCell.self, forCellWithReuseIdentifier: String.init(describing: RecomendationItemsCell.self))
        return collection
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.itemsCollectionView else {return}
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            viewModel.getPagedListOfGoodsBySubCatID()
        }
    }
    
    lazy var menuImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.image = UIImage.init(named: "menu")
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMenu)))
        return im
    }()
    
    @objc private func didTapMenu() {
        slidingController.categoryData = data?.categories
        slide.height = CGFloat(data?.categories.count ?? 1) * 50.0
        slide.direction = .bottom
        let vc = NavigationController.init(rootViewController: slidingController)
        vc.transitioningDelegate = slide
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
        
    }
    
    private func setupView() {
        let topView = Utils.getTopView(color: .lightGray)
        view.insertSubview(topBackgroundImageView, at: 0)
        view.insertSubview(containerView, aboveSubview: topBackgroundImageView)
        containerView.addSubview(searchView)
        containerView.addSubview(collectionView)
        containerView.addSubview(itemsCollectionView)
        containerView.addSubview(topView)
        containerView.addSubview(menuImageView)
        
        self.containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        self.topBackgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 300))
        topView.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 10))
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.searchView.anchor(top: topView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        menuImageView.anchor(top: searchView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        collectionView.anchor(top: searchView.bottomAnchor, leading: menuImageView.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        itemsCollectionView.anchor(top: collectionView.bottomAnchor, leading: menuImageView.leadingAnchor, bottom: view.bottomAnchor, trailing: collectionView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }

}

extension SelectedCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecomendationItemsCellProtocol {
    
    func reloadCollection() {
        self.itemsCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemsCollectionView {
            return goodsModel?.count ?? 0
        } else {
            return data?.categories.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsCell.self), for: indexPath) as! RecomendationItemsCell
            cell.delegate = self
            if let data = goodsModel?[indexPath.item] {
            cell.setItem(item: data)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: TopCategoryViewCell.self), for: indexPath) as! TopCategoryViewCell
            cell.setItem(item: data!.categories[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == itemsCollectionView {
            return CGSize(width: (SCREEN_SIZE.width - 2*16 - 2*5)/3, height: 235)
        } else {
            if let textWidth = data?.categories[indexPath.item].category.name.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) {
                return CGSize(width: textWidth, height: 25)
            }
            
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemsCollectionView {
            let vc = InfoProductSlideUpViewController()
            vc.setData(model: goodsModel?[indexPath.row])
            self.present(transition: vc)
        } else {
            selectCell(indexPath: indexPath)
        }
     
    }
    
    private func selectCell(indexPath: IndexPath) {
        collectionView.visibleCells.forEach { cell in
            guard cell is TopCategoryViewCell else {return}
            cell.isSelected = false
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? TopCategoryViewCell {
            cell.isSelected = true
        }
        if indexPath.row == 0 {
            let allData =  data?.categories.map {$0.goods}.flatMap { $0 }
            goodsModel = allData
        } else {
            goodsModel = data?.categories[indexPath.row].goods
        }
        viewModel.catID = data?.categories[indexPath.row].category.id ?? ""
        viewModel.page = 1
        self.navigationItem.title = data?.categories[indexPath.row].category.name
    }
        
}
