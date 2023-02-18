//
//  MainViewController.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 14/07/22.
//
 
import UIKit

class SavedData {
    static let shared = SavedData()
    var discountedGoods: [EachDiscountedGood]?
    var categoryWithGoods: [EachCategoryWithGoods]?
}


class MainViewController: BaseViewController, UIScrollViewDelegate {
    private let slide = SlideInPresentationManager()
    let searchView = SearchView()
    let viewModel = MainScreenViewModel()
    var canMoveUp = true
    var didChangeFrame = false
    let collectionViewHeaderFooterReuseIdentifier = "MyHeaderFooterClass"
    private var shapeLayer: CAShapeLayer?
    private var refreshControl: UIRefreshControl!
    var yPosition: CGFloat = 0.0
    let shadowView = UIView(frame: .zero)
    let reach = NetworkReachability()
    var categoryWithGoods: [EachCategoryWithGoods]? {
        didSet {
            SavedData.shared.categoryWithGoods = categoryWithGoods
            self.collectionView.reloadData()
        }
    }
   
    var categoryModel: CategoryModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var discountedGoods: [EachDiscountedGood]? {
        didSet {
            SavedData.shared.discountedGoods = discountedGoods
            self.collectionView.reloadData()
        }
    }
    
    override func backTap(_ sender: UIButton) {
        super.backTap(sender)

    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(shadowView)
        self.tabBarController?.tabBar.isHidden = false
        processingView.animatePreloader = true
        collectionView.addSubview(processingView)
        addRefresh()
        if !reach.isNetworkAvailable() {
            collectionView.addSubview(tryAgainLabel)
            collectionView.addSubview(tryAgainButton)
            tryAgainLabel.anchor(top: collectionView.topAnchor, leading: collectionView.leadingAnchor, bottom: nil, trailing: collectionView.trailingAnchor, padding: UIEdgeInsets(top: 120, left: 30, bottom: 0, right: 30))
            tryAgainLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
            tryAgainButton.anchor(top: tryAgainLabel.bottomAnchor, leading: tryAgainLabel.leadingAnchor, bottom: nil, trailing: tryAgainLabel.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 40))
            tryAgainButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        }
        
        viewModel.getCategory()
        viewModel.didGetCategoryList = { [weak self] category, error in
            guard let self = self else {return}
            if error == nil {
                var mainCategory = CategoryModel(categories: [])
                category?.categories.forEach{
                    if $0.isMainCategory {
                        mainCategory.categories.append($0)
                    }
                }
                self.categoryModel = mainCategory
            }
        }
        
        viewModel.getDiscountedGoods(page: 0)
        viewModel.didGetDiscountedGoods = { [ weak self] discountedGoods, error in
            guard let self = self else {return}
            if error == nil {
                self.discountedGoods = discountedGoods?.data ?? []
            }
        }
        
        viewModel.getMainScreenGoodCategories()
        viewModel.didGetGoodsWithCatForMain = { [weak self] result, error in
            guard let self = self else {return}
            defer {
                self.hideProcessing()
            }
            if error == nil {
                var nonEmptyCategories = [EachCategoryWithGoods]()
                result?.categories.forEach({ cat in
                    if cat.goods.isEmpty == false {
                        nonEmptyCategories.append(cat)                    }
                })
                self.categoryWithGoods = nonEmptyCategories
            } else {
            }
        }

        viewModel.didGetAddressList = { [weak self] adress, error in
            guard let self = self else {return}
            if error == nil {
                for address in adress!.addressToClients {
                    CoreDataSyncManager.shared.saveAddressToCoreData(model: address)
                }
            }
        }

        viewModel.didDeleteAddressByID = { [weak self] responce in
            guard let self = self else {return}
            if responce?.statusCode == 204 {
                print("Success")
                self.viewModel.getAddressList()
            }
        }

        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        shadowView.frame = CGRect(x: 0, y: self.collectionView.frame.minY - 3, width: SCREEN_SIZE.width, height: 14)
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
    
    @objc private func tryAgain() {
        if reach.isNetworkAvailable() {
            if collectionView.subviews.contains(tryAgainLabel), collectionView.subviews.contains(tryAgainButton) {
                tryAgainLabel.removeFromSuperview()
                tryAgainButton.removeFromSuperview()
                viewModel.getCategory()
                viewModel.getDiscountedGoods(page: 0)
                viewModel.getMainScreenGoodCategories()
            }
        }
    }
    
    
    private func addRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true
    }
    
    @objc func refresh() {
        refreshBegin { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.collectionView.frame = CGRect(x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 83 + (130 * RatioCoeff.height), width: SCREEN_SIZE.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height - (130 * RatioCoeff.height))
                self.view.layoutIfNeeded()
                self.canMoveUp = true
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshBegin(refreshEnd: @escaping () -> Void) {
            DispatchQueue.main.async {
                refreshEnd()
            }
    }
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    @objc private func didTapSearchView() {
        self.perform(transition: SearchViewController())
    }
    
    @objc private func addressLabelTapped() {
        self.openAddressSlidingController(address: CoreDataSyncManager.shared.fetchAdresses())
    }
    
    private func openAddressSlidingController(address: [EachAddress]) {
        let bottomAddressController = BottomAddressViewController()
        bottomAddressController.data = address
        bottomAddressController.delegate = self
        bottomAddressController.viewDisappeared = { [weak self] in
            guard let self = self else {return}
            self.viewModel.getAddressList()
            Utils.delay(seconds: 1) {
                self.setupAddressLabel()
            }
        }
        let height: CGFloat = address.count < 5 ? calculateSlidingControllerHeight(count: address.count) : calculateSlidingControllerHeight(count: 5)
        slide.height = height
        slide.direction = .bottom
        let vc = NavigationController.init(rootViewController: bottomAddressController)
        vc.transitioningDelegate = slide
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    private func calculateSlidingControllerHeight(count: Int) -> CGFloat {
        return 230.0 + (50 * RatioCoeff.height * CGFloat(count))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        self.collectionView.reloadData()
        self.viewModel.getAddressList()
        self.setupAddressLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if didChangeFrame == false {
            self.didChangeFrame = true
            self.collectionView.frame = CGRect(x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 63, width: SCREEN_SIZE.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height + 40.0)
        }
    }
    
    private func setupAddressLabel() {
        if CoreDataSyncManager.shared.fetchAdresses().isEmpty == false {
            if let index = UD.selectedAdressIndex{
                self.addressLabel.attributedText = NSAttributedString.getAttrTextWith(14, CoreDataSyncManager.shared.fetchAdresses()[index].address , false, Theme.current.whiteColor, .left)
            }
        }
        if CoreDataSyncManager.shared.fetchAdresses().isEmpty {
            self.addressLabel.attributedText = NSAttributedString.getAttrTextWith(14, CoreDataSyncManager.shared.fetchAdresses().first?.address ?? "addAddress".translate() , false, Theme.current.whiteColor, .left)
        }
        self.addressLabel.isHidden = CoreDataSyncManager.shared.fetchAdresses().isEmpty == true
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
    
    
    lazy var tryAgainButton: BaseButton = {
        let btn = BaseButton()
        btn.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "tryAgainLabel".translate(), false, .white, .center), for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = Theme.current.redColor
        btn.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        return btn
    }()
    
    lazy var tryAgainLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.attributedText = NSAttributedString.getAttrTextWith(17, "tryAgainButton".translate(), false, Theme.current.blackColor, .center)
        return lbl
    }()

    lazy var addressLabel: UILabel = {
        let l = UILabel()
        let text = CoreDataSyncManager.shared.fetchAdresses().isEmpty ? "addAddress".translate() : CoreDataSyncManager.shared.fetchAdresses().first?.address ?? "addAddress".translate()
        l.attributedText = NSAttributedString.getAttrTextWith(14, text, false, Theme.current.whiteColor, .left)
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressLabelTapped)))
        return l
    }()
    
    lazy var yourAddressLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(14, "Ваш адрес >", false, .white, .left)
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressLabelTapped)))
        return l
    }()
    
    lazy var promoBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.471, alpha: 0.7)
        v.layer.cornerRadius = 20
        return v
    }()
  
    lazy var promoImage: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFill
        im.image = UIImage.init(named: "promoImage")
        return im
    }()
    
    lazy var promolabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.attributedText = NSAttributedString.getAttrTextWith(14, "schoolTrain".translate(), false, Theme.current.blackColor, .left)
        return l
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        collection.decelerationRate = .normal
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.layer.cornerRadius = 20
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.register(MainScreenBottomCell.self, forCellWithReuseIdentifier: String.init(describing: MainScreenBottomCell.self))
        collection.register(MainScreenCategoryCategoryListCell.self, forCellWithReuseIdentifier: String.init(describing: MainScreenCategoryCategoryListCell.self))
        collection.register(MainViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier)
        return collection
    }()
    
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.collectionView else {return}
        view.endEditing(true)
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            
        } else {
            //up
            if canMoveUp {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                    self.collectionView.frame = CGRect(x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 63, width: SCREEN_SIZE.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height + 40.0)
                    self.collectionView.setContentOffset(.zero, animated: false)
                    self.view.layoutIfNeeded()
                    self.canMoveUp = false
                }
            }
        }
    }
    
    
    private func setupView() {
        view.addSubview(topBackgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(addressLabel)
        view.addSubview(yourAddressLabel)
        view.insertSubview(promoBackgroundView, belowSubview: collectionView)
        promoBackgroundView.addSubview(promoImage)
        promoBackgroundView.addSubview(promolabel)
        
        
        self.topBackgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 300))
        self.yourAddressLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        self.addressLabel.anchor(top: yourAddressLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 3, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        self.collectionView.frame = CGRect(x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 63, width: SCREEN_SIZE.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height + 40.0)

        promoBackgroundView.anchor(top: addressLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 130 * RatioCoeff.height))
        self.promoImage.anchor(top: promoBackgroundView.topAnchor, leading: promoBackgroundView.leadingAnchor, bottom: promoBackgroundView.bottomAnchor, trailing: nil, size: CGSize(width: self.promoBackgroundView.frame.size.width * 0.4, height: 0))
        self.promolabel.anchor(top: nil, leading: promoImage.trailingAnchor, bottom: nil, trailing: promoBackgroundView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: promoBackgroundView.frame.size.height * 0.3))
        self.promolabel.centerYAnchor.constraint(equalTo: promoBackgroundView.centerYAnchor).isActive = true
    }
   
}



extension MainViewController: SlidingAddressProtocol {
    func addNewLocation() {
        self.perform(transition: YandexMapController())
    }
    
    func editAddressById(id: String) {
        let vc = YandexMapController()
        vc.addressID  = id
        self.perform(transition: vc)
    }
    
    func deleteAddressById(id: String) {
        UD.selectedAdressIndex = nil
        viewModel.deleteAddressById(id: id)
        CoreDataSyncManager.shared.deleteAddress(by: id)
    }
    
}



extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 + (categoryWithGoods?.count ?? 0)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainScreenCategoryCategoryListCell.self), for: indexPath) as! MainScreenCategoryCategoryListCell
            cell.categoryModel = categoryModel
            cell.didTapCategory = { [weak self] catID in
                guard let self = self else {return}
                let vc = SelectedCategoryViewController()
                vc.categoryID = catID
                self.perform(transition: vc)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainScreenBottomCell.self), for: indexPath) as! MainScreenBottomCell
            cell.categoryName.attributedText = NSAttributedString.getAttrTextWith(17, "discountAnd".translate(), false, Theme.current.blackColor)
            cell.discountedGoodsModel = discountedGoods
            cell.isFavoritesCell = false
            
            cell.didTapMore = { [weak self] in
                guard let self = self else {return}
                let vc = DiscountedGoodsViewController()
                vc.isFavoriteView = false
                vc.goodsModel = self.discountedGoods
                self.perform(transition: vc)
            }
            
            cell.didTapCategoryName = { [weak self] in
                guard let self = self else {return}
                let vc = DiscountedGoodsViewController()
                vc.isFavoriteView = false
                vc.goodsModel = self.discountedGoods
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
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainScreenBottomCell.self), for: indexPath) as! MainScreenBottomCell
            cell.categoryName.attributedText = NSAttributedString.getAttrTextWith(17, "favourites".translate(), false, Theme.current.blackColor)
            cell.isFavoritesCell = true
            cell.discountedGoodsModel = CoreDataSyncManager.shared.fetchLikedGoods().reversed()
            cell.didTapMore = { [weak self] in
                guard let self = self else {return}
                let vc = LikedGoodsViewController()
                vc.goodsModel = CoreDataSyncManager.shared.fetchLikedGoods()
                self.perform(transition: vc)
            }
            
            cell.didTapCategoryName = { [weak self] in
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
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MainScreenBottomCell.self), for: indexPath) as! MainScreenBottomCell
            cell.categoryName.attributedText = NSAttributedString.getAttrTextWith(17, categoryWithGoods?[indexPath.row - 3].category.name ?? "", false, Theme.current.blackColor)
            cell.discountedGoodsModel = categoryWithGoods?[indexPath.row - 3].goods
            cell.isFavoritesCell = false
            
            cell.didTapMore = { [weak self] in
                guard let self = self else {return}
                let vc = SelectedCategoryViewController()
                vc.categoryID = self.categoryWithGoods?[indexPath.row - 3].category.id ?? ""
                self.perform(transition: vc)
            }
            
            cell.didTapCategoryName = { [weak self] in
                guard let self = self else {return}
                let vc = SelectedCategoryViewController()
                vc.categoryID = self.categoryWithGoods?[indexPath.row - 3].category.id ?? ""
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
        
            return cell
        }
       
    }

   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let heightOfEachCircleCell = (collectionView.frame.size.width - (15*2 + 30)) / 4
       let heightOfEachCatCell = heightOfEachCircleCell + 40 // 5top+5bottom+30label
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.frame.size.width, height: heightOfEachCatCell*2 + 30)
        default:
            return CGSize(width: collectionView.frame.size.width, height: 285)
        }
   
    }
   

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.row == 0 {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderFooterReuseIdentifier, for: indexPath) as! MainViewHeaderView
                let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                headerView.isUserInteractionEnabled = true
                headerView.addGestureRecognizer(gestureRecognizer)
                headerView.searchView.textField.isUserInteractionEnabled = false
                headerView.searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSearchView)))
                headerView.searchView.clearImageView.isHidden = true
                return headerView
            }
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
             
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let senderView = gestureRecognizer.view else { return }
        guard let parentView = senderView.superview?.superview else { return }
        let translation = gestureRecognizer.translation(in: parentView)
        
        if gestureRecognizer.state == .began {
            yPosition = senderView.superview?.frame.minY ?? 0.0
            
        }
        if gestureRecognizer.state == .changed {
            let newPos = CGPoint(x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + yPosition + translation.y)
            if newPos.y > self.view.safeAreaLayoutGuide.layoutFrame.minY + 63 && newPos.y < self.view.safeAreaLayoutGuide.layoutFrame.minY + 83 + (130 * RatioCoeff.height) {
                self.collectionView.frame = CGRect(x: 0, y: newPos.y, width: view.frame.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height + 40.0)
                parentView.layoutIfNeeded()
            }
            
            
            
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0.0, height: 90.0)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
 
}


