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
    let searchView = SearchView()
    private let slide = SlideInPresentationManager()
    var categoryID: String?
    let viewModel = MainScreenViewModel()
    var shouldSelect = true
    let shadowView = UIView(frame: .zero)
    private var shapeLayer: CAShapeLayer?
    var data: CategoryWithGoods? {
        didSet {
            collectionView.reloadData()
            itemsCollectionView.reloadData()
            self.navigationItem.titleView = twoLineTitleView(text: data?.categories.first?.category.name ?? "", color: UIColor.white)
//            self.navigationItem.title = data?.categories.first?.category.name
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
        self.showProcessing()
        view.backgroundColor = Theme.current.gradientColor1
        view.addSubview(shadowView)
        
        if let catID = categoryID {
            self.viewModel.getGoodsByCategoryID(catID: catID)
        }
        
        viewModel.didGetGoodsWithCat = { [weak self] goods, error in
            guard let self = self else {return}
            defer {
                self.hideProcessing()
            }
            if error == nil {
                if goods?.categories.isEmpty == false {
                    var appendedGoodsData = goods
                    appendedGoodsData?.categories = goods?.categories.filter({$0.goods.isEmpty == false}) ?? []
                    self.data = appendedGoodsData
                    
                    Utils.delay(seconds: 0.1) {
                        if let firstCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? TopCategoryViewCell {
                            firstCell.isSelected = true
                            let allData =  self.data?.categories.map {$0.goods}.flatMap { $0 }
                            self.goodsModel = allData
                        }
                    }
                }
            }
        }
        
        searchView.textField.isUserInteractionEnabled = false
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSearchView)))
        searchView.clearImageView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        shadowView.frame = CGRect(x: 0, y: self.containerView.frame.minY - 3, width: SCREEN_SIZE.width, height: 14)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 1.0)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 20).cgPath
        shapeLayer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        shapeLayer.shadowOpacity = 1.0
        shapeLayer.shadowRadius = 4
        shapeLayer.borderWidth = 0.2
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shouldRasterize = true
        shapeLayer.rasterizationScale = UIScreen.main.scale
        if let oldShapeLayer = self.shapeLayer {
            shadowView.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            shadowView.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    @objc private func didTapSearchView() {
        self.perform(transition: SearchViewController())
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = view.bounds
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(l, at: 0)
        return l
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteColor
        v.layer.cornerRadius = 20
        return v
    }()
  
    lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(RecomendationItemsCell.self, forCellWithReuseIdentifier: String.init(describing: RecomendationItemsCell.self))
        collection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.isUserInteractionEnabled = true
        collection.register(TopCategoryViewCell.self, forCellWithReuseIdentifier: String.init(describing: TopCategoryViewCell.self))

        return collection
    }()
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.shouldSelect = true
    }
    
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.itemsCollectionView else {return}
        let center = self.view.convert(self.itemsCollectionView.center, to: self.itemsCollectionView)
        if shouldSelect {
            if let index = itemsCollectionView.indexPathForItem(at: center) {
                collectionView.visibleCells.forEach { cell in
                    guard cell is TopCategoryViewCell else {return}
                    cell.isSelected = false
                }
                if let cell = collectionView.cellForItem(at: IndexPath(row: index.section, section: 0)) as? TopCategoryViewCell {
                    cell.isSelected = true
                }
            }
            if let index = itemsCollectionView.indexPathForItem(at: center) {
                self.navigationItem.titleView = twoLineTitleView(text: data?.categories[index.section].category.name ?? "", color: UIColor.white)
                
            }
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
    
    //SOS menyu ikonkani figmadan orqasi yogidan olib oshani ornating va didTapMenu() chaqirilganda orqasini rangi ozgarsin didSelectCategory closure ishlaganda yana clear bobqolsin
    
    lazy var collectionBackgroundView: UIView = {
        let im = UIView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.backgroundColor = .lightGray
        im.backgroundColor = Theme.current.grayBackgraoundColor
        return im
    }()
    
    @objc private func didTapMenu() {
        let slidingController = MenuSlidingViewController()
        slidingController.didSelectCategory = { [weak self] index in
            guard let self = self else {return}
            self.selectCell(indexPath: IndexPath(row: index, section: 0))
        }
        slidingController.categoryData = data?.categories
        slide.height = SCREEN_SIZE.height * 0.5
        slide.direction = .bottom
        let vc = NavigationController.init(rootViewController: slidingController)
        vc.transitioningDelegate = slide
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    private func setupView() {
//        let topView = Utils.getTopView(color: .lightGray)
        view.insertSubview(topBackgroundImageView, at: 0)
        view.insertSubview(containerView, aboveSubview: topBackgroundImageView)
        containerView.addSubview(searchView)
        containerView.addSubview(collectionView)
        containerView.addSubview(itemsCollectionView)
//        containerView.addSubview(topView)
        containerView.addSubview(menuImageView)
        containerView.insertSubview(collectionBackgroundView, belowSubview: collectionView)
        
        self.containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        self.topBackgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 300))
//        topView.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 5))
//        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.searchView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        menuImageView.anchor(top: searchView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 25, height: 25))
        collectionView.anchor(top: searchView.bottomAnchor, leading: menuImageView.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        itemsCollectionView.anchor(top: collectionView.bottomAnchor, leading: containerView.leadingAnchor, bottom: view.bottomAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        collectionBackgroundView.anchor(top: searchView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 46))
    }

}

extension SelectedCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecomendationItemsCellProtocol {
    
    func reloadCollection(afterLike: Bool) {
        self.itemsCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == itemsCollectionView {
            return data?.categories.count ?? 0
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemsCollectionView {
            return data?.categories[section].goods.count ?? 0
        } else {
            return data?.categories.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == itemsCollectionView {
            if section < data?.categories.count ?? 0 {
                return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            } else {
                return UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
            }
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsCell.self), for: indexPath) as! RecomendationItemsCell
            cell.delegate = self
            if let datas = data?.categories[indexPath.section].goods[indexPath.row] {
                cell.setItem(item: datas, categoryName: data?.categories[indexPath.section].category.name ?? "" )
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
                return CGSize(width: textWidth + 3, height: 25)
            }
            
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == itemsCollectionView {
            if kind == UICollectionView.elementKindSectionHeader {
                 let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
                sectionHeader.label.attributedText = NSAttributedString.getAttrTextWith(17, data?.categories[indexPath.section].category.name ?? "", false, Theme.current.blackColor)
                 return sectionHeader
            } else {
                 return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == itemsCollectionView && section != 0 {
            return CGSize(width: collectionView.frame.width, height: 20)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemsCollectionView {
            let vc = InfoProductSlideUpViewController()
            vc.setData(model: data?.categories[indexPath.section].goods[indexPath.row])
            vc.shouldReloadCollection = { [weak self] in
                self?.itemsCollectionView.reloadData()
            }
            self.present(transition: vc)
        } else {
            selectCell(indexPath: indexPath)
        }
    }
    
    private func selectCell(indexPath: IndexPath) {
        self.shouldSelect = false
        self.navigationItem.titleView = twoLineTitleView(text: data?.categories[indexPath.row].category.name ?? "", color: UIColor.white)
        self.itemsCollectionView.scrollToItem(at:IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
        for row in  0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TopCategoryViewCell {
                cell.isSelected = false
            }
        }
        if let cell = self.collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? TopCategoryViewCell {
            cell.isSelected = true
        }
    }
}
