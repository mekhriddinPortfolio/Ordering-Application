//
//  BasketController.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 06/07/22.
//

import UIKit
import CoreGraphics

class BasketController: BaseViewController {
    
    let deliveryView = DeliveryTopView()
    let cancelView = CancelDeletionView()
    var secondsRemaining = 8
    var timerTest: Timer? = nil
    var isCancelTapped = false
    let emptyListView = BasketEmptyView(frame: CGRect(x: 0, y: 0, width: 0, height: (150 * RatioCoeff.height) + 210))
    var summary: String = ""
    var heightConstraint : NSLayoutConstraint?
    var collectionHeightConstraint : NSLayoutConstraint?
    var color1 = Theme.current.gradientLabelColors[0]
    var color2 = Theme.current.gradientLabelColors[1]
    let viewModel = MainScreenViewModel()
    var collectionTopConstraint: NSLayoutConstraint?
    let shadowView = UIView(frame: .zero)
    private var shapeLayer: CAShapeLayer?
    var items = [EachDiscountedGoodForCoreData]() {
        didSet {
            tableView.reloadData()
            if items.isEmpty {
                containerScrollView.insertSubview(emptyListView, aboveSubview: tableView)
                emptyListView.anchor(top: containerScrollView.topAnchor, leading: containerScrollView.leadingAnchor, bottom: nil, trailing: containerScrollView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: SCREEN_SIZE.width, height: (150 * RatioCoeff.height) + 210))
                tableView.isHidden = true
                bottomInfoView.isHidden = true
                heightConstraint?.constant = (150 * RatioCoeff.height) + 100.0
                self.view.layoutIfNeeded()
            } else {
                heightConstraint?.constant = (CGFloat(items.count) * (90.0) + 10)
                self.view.layoutIfNeeded()
                if containerScrollView.subviews.contains(emptyListView) {
                    emptyListView.removeFromSuperview()
                    tableView.isHidden = false
                    bottomInfoView.isHidden = false
                }
                var amountArray = [0]
                self.items.forEach { item in
                    amountArray.append(Int(Double(item.sellingPrice) * (1.0 - item.discount) * Double(item.count)))
                }
                let summary = Utils.numberToCurrency(number: amountArray.reduce(0, {$0 + $1}))
                self.summary = summary
                self.bottominfoLabel.attributedText = NSAttributedString.getAttrTextWith(24, "\(self.summary)", false, .lightGray, .left)
            }
            
            Utils.delay(seconds: 0.5) {
                if self.items.isEmpty {
                    self.containerScrollView.contentSize = CGSize(width: SCREEN_SIZE.width, height: 800)
                } else {
                    self.containerScrollView.contentSize = CGSize(width: SCREEN_SIZE.width, height: (CGFloat(self.items.count) * (90.0) + 570))
                }
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.addSubview(shadowView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BasketCell.self, forCellReuseIdentifier: String.init(describing: BasketCell.self))
        
        cancelView.isHidden = true
        emptyListView.clipsToBounds = true
        bottominfoButton.addTarget(self, action: #selector(goToFormatilizationTapped), for: .touchUpInside)
        emptyListView.goProductsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goProductsButtonTapped)))
        cancelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelDeletionTapped)))
        
        viewModel.didGetGoodsWithCat = { [weak self] goods, error in
            guard let self = self else {return}
            if error == nil {
                if goods?.categories.isEmpty == false {
                    let vc = SelectedCategoryViewController()
                    vc.goodsModel = goods?.categories[0].goods
                    var appendedGoodsData = goods
                    let newCat = EachCategoryWithGoods()
                    appendedGoodsData?.categories.insert(newCat, at: 0)
                    vc.data = appendedGoodsData
                    self.perform(transition: vc)
                }
            }
        }
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = twoLineTitleView(text: "cart".translate(), color: UIColor.white)
        self.tabBarController?.tabBar.isHidden = false
        setupNavbar()
        self.items = CoreDataSyncManager.shared.fetchGoodsData()
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if items.isEmpty {
//            containerScrollView.contentSize = CGSize(width: SCREEN_SIZE.width, height: 720.0)
//        } else {
//            containerScrollView.contentSize = CGSize(width: SCREEN_SIZE.width, height: (CGFloat(items.count) * (90.0) + 560))
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        shadowView.frame = CGRect(x: 0, y: self.containerScrollView.frame.minY - 3, width: SCREEN_SIZE.width, height: 14)
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
  
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = view.bounds
        l.colors = [color1, color2]
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(l, at: 0)
        return l
    }()
    
    lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layer.cornerRadius = 20
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.separatorStyle = .none
        t.backgroundColor = .white
        t.alwaysBounceVertical = false
        t.bounces = false
        t.contentInset = UIEdgeInsets.zero
        t.showsVerticalScrollIndicator = false
        t.isScrollEnabled = false
        return t
    }()
    
    lazy var bottomInfoView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var bottominfoButton: BaseButton = {
        let b = BaseButton(title: "design".translate(), size: 15)
        b.layer.borderWidth = 0
        return b
    }()
    
    lazy var bottominfoLabel: GradientLabel = {
        let l = GradientLabel()
        
        l.gradientColors = Theme.current.gradientLabelColors
        l.numberOfLines = 0
        return l
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collection.decelerationRate = .normal
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.layer.cornerRadius = 20
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.register(MainScreenBottomCell.self, forCellWithReuseIdentifier: String.init(describing: MainScreenBottomCell.self))
        collection.register(BottomRecomendedCell.self, forCellWithReuseIdentifier: String.init(describing: BottomRecomendedCell.self))
        
        return collection
    }()
    
    private func setupView() {
        view.insertSubview(topBackgroundImageView, at: 0)
        view.insertSubview(containerScrollView, aboveSubview: topBackgroundImageView)
        view.insertSubview(bottomInfoView, aboveSubview: containerScrollView)
        view.insertSubview(cancelView, aboveSubview: containerScrollView)
        
        topBackgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 160))
        
        containerScrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        containerScrollView.addSubview(deliveryView)
        containerScrollView.addSubview(tableView)
        containerScrollView.addSubview(collectionView)
        
        deliveryView.anchor(top: containerScrollView.topAnchor, leading: containerScrollView.leadingAnchor, bottom: nil, trailing: containerScrollView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), size: CGSize(width: SCREEN_SIZE.width - 40, height: 120))
        tableView.anchor(top: deliveryView.bottomAnchor, leading: containerScrollView.leadingAnchor, bottom: nil, trailing: containerScrollView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        heightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
        tableView.addConstraint(heightConstraint!)
        
        bottomInfoView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 70))
        bottomInfoView.addSubview(bottominfoLabel)
        bottomInfoView.addSubview(bottominfoButton)
        bottominfoButton.anchor(top: nil, leading: nil, bottom: nil, trailing: bottomInfoView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 150, height: 56))
        bottominfoButton.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor).isActive = true
        bottominfoLabel.anchor(top: nil, leading: bottomInfoView.leadingAnchor, bottom: nil, trailing: bottominfoButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 0), size: CGSize(width: 0, height: 56))
        bottominfoLabel.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor).isActive = true
        bottomInfoView.setStyleWithShadow()
        
        cancelView.anchor(top: nil, leading: containerScrollView.leadingAnchor, bottom: containerScrollView.bottomAnchor, trailing: containerScrollView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 10 + (tabBarController?.tabBar.frame.size.height ?? 0.0), right: 16), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        collectionView.anchor(top: nil, leading: containerScrollView.leadingAnchor, bottom: nil, trailing: containerScrollView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        collectionHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 285)
        collectionView.addConstraint(collectionHeightConstraint!)
        collectionHeightConstraint?.isActive = true
        collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20)
        collectionTopConstraint?.isActive = true
   
    }
    
    
    
    
    private func setupNavbar() {
        let newImage = UIImage.imageWithImage(image: UIImage.init(named: "deleteNav")!,
                                              scaledToSize: CGSize(width: 42, height: 42))
        let deleteButton = UIBarButtonItem(image: newImage.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapDelete(_:)))
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc func didTapDelete (_ sender: UIButton) {
        showAlertMessage(firstText: "Вы уверены?", secondText: "Вы действительно хотите удалить весь товар добавленный в корзину") {
            self.dismiss(animated: true) {
                self.items = []
                self.cancelView.isHidden = false
                self.activateTimer()
//                self.containerScrollView.contentSize = CGSize(width: SCREEN_SIZE.width, height: (CGFloat(self.items.count) * (70 * RatioCoeff.height) + 450.0))
            }
        } cancel: {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func goProductsButtonTapped() {
        self.tabBarController?.selectedIndex = 1
        if let tabbar = self.tabBarController as? MainTabbarController {
            tabbar.basketImage.image = tabbar.basketImage.image?.withRenderingMode(.alwaysTemplate)
            tabbar.basketImage.tintColor = .lightGray
            tabbar.imageV.image = tabbar.imageV.image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc func cancelDeletionTapped() {
        self.items = CoreDataSyncManager.shared.fetchGoodsData()
        self.isCancelTapped = true
        self.cancelView.isHidden = true
    }
    
    @objc func goToFormatilizationTapped() {
        var dictionaryArray = [[String:Any]]()
        self.items.forEach({ good in
            let orderDic: [String: Any] = ["goodId": good.id, "count" : good.count]
            dictionaryArray.append(orderDic)
        })
        let vc = FormalizationViewController(items: dictionaryArray, summary: self.summary)
        perform(transition: vc)
    }
    
    func activateTimer() {
        timerTest = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (Timer) in
            guard let self = self else {return}
              if self.secondsRemaining > 0 {
                  self.secondsRemaining -= 1
              } else {
                  if !self.isCancelTapped {
                      Utils.delay(seconds: 0) {
                          CoreDataSyncManager.shared.deleteBasketGoods()
                          self.items = CoreDataSyncManager.shared.fetchGoodsData()
                          self.cancelView.isHidden = true
                      }
                  }
                  Timer.invalidate()
              }
          }
    }
    
}


extension BasketController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: BasketCell.self), for: indexPath) as! BasketCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setData(model: items[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, handler in
            guard let self = self else {return}
            CoreDataSyncManager.shared.deleteItem(by: self.items[indexPath.row].id)
            Utils.delay(seconds: 0.5) {
                self.items = CoreDataSyncManager.shared.fetchGoodsData()
            }
        }
        deleteAction.backgroundColor = .white
        let rect = CGRect(x: 0, y: 0, width: 60, height: 90)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { c in
//            let rounded = UIBezierPath(roundedRect: rect, cornerRadius: 10)
//            rounded.addClip()
//            UIColor(hex: "#D82F3C").setFill()
//            rounded.fill()
//            UIImage(named: "deleteIcon")?.draw(in: CGRect(x: (60)/2 - 10, y: (80)/2 - 10, width: 20, height: 20))
            UIImage(named: "deleteSwipe")?.draw(in: CGRect(x: 0, y: 10, width: 60, height: 80))
        }
        deleteAction.image = result
        var actions: [UIContextualAction] = [deleteAction]
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension BasketController: BasketCellProtocol {
    func reloadCollection() {
        self.items = CoreDataSyncManager.shared.fetchGoodsData()
    }
}


extension BasketController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainScreenBottomCell.self), for: indexPath) as! MainScreenBottomCell
        cell.categoryName.text = "favourites".translate()
        cell.isFavoritesCell = true
        cell.discountedGoodsModel = CoreDataSyncManager.shared.fetchLikedGoods()
        cell.didTapMore = { [weak self] in
            guard let self = self else {return}
            let vc = LikedGoodsViewController()
            vc.goodsModel = CoreDataSyncManager.shared.fetchLikedGoods()
            self.perform(transition: vc)
        }
        
        cell.didTapItem = { [weak self] selectedData in
            guard let self = self else {return}
            let infoSlideController = InfoProductSlideUpViewController()
            infoSlideController.shouldReloadCollection = { [weak self] in
                guard let self = self else {return}
                cell.collectionView.reloadData()
            }
            infoSlideController.setData(model: selectedData)
            self.present(transition: infoSlideController)
            
        }
        cell.shouldReload = { [weak self] in
            guard let self = self else {return}
            self.collectionView.reloadData()
        }
        
        cell.didEditCount = { [weak self] in
            guard let self = self else {return}
            self.reloadCollection()
        }
        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 285)
    }
   
 
}

