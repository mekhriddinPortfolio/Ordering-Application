//
//  LikedGoodsVC.swift
//  Oq ot
//
//  Created by AvazbekOS on 24/08/22.
//

import UIKit

protocol LikedGoodsProtocol: AnyObject {
    func openDetailedInfo(model: EachDiscountedGood?)
}

class LikedGoodsViewController: BaseViewController {
    
    var isFavoriteView: Bool = true
    weak var delegate: LikedGoodsProtocol?
    var goodsModel: [EachDiscountedGood]? {
        didSet {
            if let goodsModel = goodsModel {
                if (goodsModel.isEmpty) {
                    emptyCaseView.isHidden = false
                } else {
                    emptyCaseView.isHidden = true
                }
            }
            collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBackgroundImageView.tintColor = Theme.current.gradientColor1
        view.backgroundColor = Theme.current.whiteColor
        emptyCaseView.actionButton.addTarget(self, action: #selector(goForMainTapped), for: .touchUpInside)
        setEmptyCondition()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.titleView = twoLineTitleView(text: isFavoriteView ? "favourites".translate() : "Скидки и скидки".translate(), color: UIColor.white)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    let emptyCaseView = EmptyReusableView(imageName: "likeEmptyImg", text: "Избранных нет", desc: "На данный момент , список ваших избранных товаров пуст.", buttonTitle: "Продолжить покупки", height: 135*RatioCoeff.height, leftRightPadding: 40*RatioCoeff.width)
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteColor
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
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
    
    @objc func goForMainTapped() {
        defer {
            self.back(with: .pop)
        }
        self.tabBarController?.selectedIndex = 1
        if let tabbar = self.tabBarController as? MainTabbarController {
            tabbar.profileImage.image = tabbar.profileImage.image?.withRenderingMode(.alwaysTemplate)
            tabbar.profileImage.tintColor = .lightGray
            tabbar.imageV.image = tabbar.imageV.image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func setEmptyCondition() {
        if goodsModel == nil || goodsModel?.isEmpty ?? true {
            emptyCaseView.isHidden = false
        } else {
            emptyCaseView.isHidden = true
        }
    }
    
    private func setupView() {
        
        view.insertSubview(topBackgroundImageView, at: 0)
        view.insertSubview(containerView, aboveSubview: topBackgroundImageView)
        
        containerView.addSubview(collectionView)
        containerView.insertSubview(emptyCaseView, aboveSubview: collectionView)
        
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        
        self.collectionView.anchor(top: containerView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        
        self.emptyCaseView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    
        let screenSize = UIScreen.main.bounds.size
        topBackgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: (screenSize.width - 50), height: (screenSize.width - 50) * 2 / 3))
    }
}

extension LikedGoodsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecomendationItemsCellProtocol {

    func reloadCollection(afterLike: Bool) {
        self.collectionView.reloadData()
        if isFavoriteView {
            goodsModel = CoreDataSyncManager.shared.fetchLikedGoods()
        } else {
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: RecomendationItemsCell.self), for: indexPath) as! RecomendationItemsCell
        cell.delegate = self
        if let data = goodsModel?[indexPath.item] {
        cell.setItem(item: data, categoryName: isFavoriteView ? "favourites".translate() : "Скидки и скидки".translate())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (SCREEN_SIZE.width - 2*16 - 2*5)/3, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = InfoProductSlideUpViewController()
            vc.setData(model: goodsModel?[indexPath.row])
            self.present(transition: vc)
    }
        
}


class DiscountedGoodsViewController: LikedGoodsViewController {
    let viewModel = MainScreenViewModel()
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didGetDiscountedGoods = { [ weak self] discountedGoods, error in
            guard let self = self else {return}
            if error == nil {
                var modelArray = self.goodsModel
                discountedGoods?.data.forEach({ model in
                    modelArray?.append(model)
                })
                self.goodsModel = modelArray ?? []
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            self.page += 1
            viewModel.getDiscountedGoods(page: page)
        }
    }
    
}
