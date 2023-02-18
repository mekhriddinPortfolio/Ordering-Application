//
//  FormalizationViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 27/07/22.
//

import UIKit
import YandexMapsMobile

class FormalizationViewController: BaseViewController {
    private let slide = SlideInPresentationManager()
    let formalizationSwitcher = FormalizationTypeSwitcherView()
    let deliveryView = DeliveryView()
    let pickupView = PickupView()
    var goods = [[String:Any]]()
    var summary = ""
    var formalizationModel = FormalizationModel()
    var formalizationViewModel = FormalizationViewModel()
    var shouldSetAddress = true
//    let kvOrOfficeViewController = KvOrOfficeViewController()
    
    convenience init(items: [[String:Any]], summary: String) {
        self.init()
        self.goods = items
        self.summary = summary
        var count = 0
        items.forEach { item in
            count += item["count"] as! Int
        }
        deliveryView.count = count
        pickupView.count = count
        deliveryView.summary = summary
        pickupView.summary = summary
    }
    
    var storeLocationList: [EachStore]? {
        didSet {
            if let list = storeLocationList {
                self.setApiAdress(list: list)
            }
        }
    }
    var paymentTypeList: [EachPaymentType]?
    
    private func setApiAdress(list: [EachStore], selectedAddress: EachStore? = nil ) {
        if let pickupAddressCell = pickupView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormalizationPickupCell {
            formalizationModel.toLongitudeForPickup = selectedAddress == nil ? list[0].longitude : selectedAddress?.longitude
            formalizationModel.toLatitudeForPickup = selectedAddress == nil ? list[0].latitude : selectedAddress?.latitude
            let address = selectedAddress == nil ? list.first?.address ?? "" : selectedAddress?.address ?? ""
            let phoneNumber = selectedAddress == nil ? list.first?.phoneNumber ?? "" : selectedAddress?.phoneNumber ?? ""
            pickupAddressCell.streetLabel.attributedText = NSAttributedString.getAttrTextWith(15, address, false, UIColor(hex: "#848484", alpha: 1.0), .center)
            pickupAddressCell.placePhoneLabel.attributedText = NSAttributedString.getAttrTextWith(15, phoneNumber, false, UIColor(hex: "#000000", alpha: 0.6), .left)
                pickupAddressCell.yandexMapsLocationView.clusterPoints = getClusterPoints(data: list)
                pickupAddressCell.yandexMapsLocationView.addPins()
        }
    }
    
    
    private func getClusterPoints(data: [Any]) -> [YMKPoint] {
        if let data = data as? [EachStore] {
            var pointsArray: [YMKPoint] = []
            data.forEach { data in
                let point = YMKPoint(latitude: data.latitude ?? 0.0, longitude: data.longitude ?? 0.0)
                pointsArray.append(point)
            }
            return pointsArray
        } else if let data = data as? [EachAddress]{
            var pointsArray: [YMKPoint] = []
            data.forEach { data in
                let point = YMKPoint(latitude: data.latitude , longitude: data.longitude )
                pointsArray.append(point)
            }
            return pointsArray
        }
        return [YMKPoint()]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#DE8706")
        pickupView.isHidden = true
        deliveryView.delegate = self
        pickupView.delegate = self
        setupView()
        formalizationSwitcher.didChangeSwitch = { [weak self] index in
            guard let self = self else {return}
            self.toggleViews(showFirst: index == 1)
        }
        bottominfoButton.addTarget(self, action: #selector(completeDidTappedFormatilization), for: .touchUpInside)
        
        formalizationViewModel.didSendFormalization = { [weak self] response, error in
            guard let self = self else {return}
            if response?.statusCode == 200 {
                let vc = OrderSlideUpViewController()
                self.perform(transition: vc)
            } else if response?.statusCode == 404 {
                self.showAlertMessage(firstText: "Error!", secondText: "Formalization is not successful: error in Sending Formalization Details", buttonType: .oneButton) {
                    self.dismiss(animated: true) {
                        self.back(with: .toOrigin)
                    }
                } cancel: {
                    self.dismiss(animated: true) {
                        self.back(with: .toOrigin)
                    }
                }
                print("error IN Sending Formalization Details")
            }
        }
        
        formalizationViewModel.getListOfStores()
        formalizationViewModel.didGetListOfStores = { [weak self] stores, error in
            guard let self = self else {return}
            if error == nil {
                self.storeLocationList = stores?.stores
            }
        }
        
        formalizationViewModel.getPaymentTypes()
        formalizationViewModel.didGetListOfPaymentTypes = { [weak self] type, error in
            guard let self = self else {return}
            if error == nil {
                self.paymentTypeList = type?.paymentTypes
            }
        }
        AppDelegate.shared?.sendNotification()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewEndEditing)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = twoLineTitleView(text: "checkoutOrder".translate(), color: UIColor.white)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldSetAddress {
            setCoreDataAdresses()
        }
//        kvOrOfficeViewController.chosenDestinationType = {[weak self] type, name in
//            guard let self = self else {return}
//            self.formalizationModel.destinationType = type
//            if let deliveryCell = self.deliveryView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormalizationDeliveryCell {
//                deliveryCell.kvLabel.attributedText = NSAttributedString.getAttrTextWith(15, name, false, UIColor(hex: "#000000", alpha: 0.6), .left)
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    @objc func viewEndEditing() {
        view.endEditing(true)
    }
    
    private func setCoreDataAdresses(fromMaps: Bool = false, address: EachAddress? = nil) {
        if let deliveryCell = deliveryView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormalizationDeliveryCell {
            let adresses = CoreDataSyncManager.shared.fetchAdresses()
            if adresses.isEmpty == false {
                deliveryCell.yandexMapsLocationView.clusterPoints = getClusterPoints(data: adresses)
                deliveryCell.yandexMapsLocationView.addPins()
                formalizationModel.toLongitude = address == nil ? adresses[UD.selectedAdressIndex ?? 0].longitude : address?.longitude
                formalizationModel.toLatitude = address == nil ? adresses[UD.selectedAdressIndex ?? 0].latitude : address?.latitude
            }
            if fromMaps {
                deliveryCell.streetLabel.attributedText = NSAttributedString.getAttrTextWith(15, address?.address ?? "", false, UIColor(hex: "#848484", alpha: 1.0), .center)
            } else {
                if adresses.isEmpty == false {
                    deliveryCell.streetLabel.attributedText = NSAttributedString.getAttrTextWith(15, adresses[UD.selectedAdressIndex ?? 0].address, false, UIColor(hex: "#848484", alpha: 1.0), .center)
                    self.shouldSetAddress = false
                }
            }
        }
    }
    
    
    
    @objc func completeDidTappedFormatilization() {
        formalizationModel.goods = goods
        formalizationModel.dontCallWhenDelivered = !deliveryView.isCalling
        formalizationViewModel.sendFormalizationDetails(formalizationModel: formalizationModel)
    }
    
    private func calculateSlideHeight(count: Int) -> CGFloat {
        let collection = (50 * RatioCoeff.height * CGFloat(count))
        let height = 110.0 + (100.0 * RatioCoeff.height) + collection
        return height
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

    lazy var bottomInfoView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var bottominfoButton: BaseButton = {
        let b = BaseButton(title: "design".translate(), size: 15)
        b.layer.borderWidth = 0
        return b
    }()
    
    lazy var bottominfoLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(17, "\(summary)", false, UIColor(hex: "#DE8706", alpha: 1.0), .center)
        return l
    }()

    lazy var switcherView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        v.backgroundColor = .white
        return v
    }()
    
    private func toggleViews(showFirst: Bool) {
        formalizationModel.isPickup = !showFirst
        deliveryView.isHidden = !showFirst
        pickupView.isHidden = showFirst
    }
    
    private func setupView() {
        view.insertSubview(topBackgroundImageView, at: 0)
        view.insertSubview(switcherView, aboveSubview: topBackgroundImageView)
        view.insertSubview(deliveryView, aboveSubview: topBackgroundImageView)
        view.insertSubview(pickupView, aboveSubview: topBackgroundImageView)
        switcherView.addSubview(formalizationSwitcher)
        view.insertSubview(bottomInfoView, aboveSubview: switcherView)
        
        topBackgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 160))
        
        switcherView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80*RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 51 + (2*12)))
        formalizationSwitcher.anchor(top: switcherView.topAnchor, leading: switcherView.leadingAnchor, bottom: switcherView.bottomAnchor, trailing: switcherView.trailingAnchor)
        
        deliveryView.anchor(top: switcherView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        pickupView.anchor(top: switcherView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        bottomInfoView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 80 * RatioCoeff.height))
        bottomInfoView.addSubview(bottominfoLabel)
        bottomInfoView.addSubview(bottominfoButton)
        bottominfoLabel.anchor(top: nil, leading: bottomInfoView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 0), size: CGSize(width: 100, height: 25))
        bottominfoLabel.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor).isActive = true
        bottominfoButton.anchor(top: nil, leading: nil, bottom: nil, trailing: bottomInfoView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 150, height: 46))
        bottominfoButton.centerYAnchor.constraint(equalTo: bottomInfoView.centerYAnchor).isActive = true
        bottomInfoView.setStyleWithShadow()
    }
    
}

extension FormalizationViewController:  DeliveryProtocol, PickupProtocol {
    
    func didEndCommiting(comment text: String) {
        self.formalizationModel.comment = text
    }
    func didEndChosingTime(date text: String) {
        self.formalizationModel.deliverAt = text
        print("FORMALIZATION DELIVERY AT")
    }
    
    func didEndEntringEntrance(entrance text: String?) {
        if let text = text {
            self.formalizationModel.entrance = Int(text)!
            print("FORMALIZATION EntringEntrance ")
        }
    }
    func didEndEntringFloor(floor text: String?) {
        if let text = text {
            self.formalizationModel.floor = Int(text)!
            print("FORMALIZATION EntringFloor ")
        }
    }
    func didEndEntringKv(kv text: String?) {
        if let text = text, text != "" {
            self.formalizationModel.destinationType = Int(text)!
            print("FORMALIZATION EntringFloor ")
        }
    }
    func promoCodeViewShow() {
        let promoCodeViewController = PromoCodeViewController()
        openSlidingController(controller: promoCodeViewController, height: SCREEN_SIZE.height * 0.6)
    }
    func techSupportViewShow() {
        let techSupportViewController = TechSupportViewController()
        openSlidingController(controller: techSupportViewController, height: 280*RatioCoeff.height)
    }
//    func kvOrOfficeViewShow() {
//        openSlidingController(controller: kvOrOfficeViewController, height: 200*RatioCoeff.height)
//    }
   
    func cashViewShow() {
        let cashOrTerminalViewController = CashOrTerminalViewController()
        cashOrTerminalViewController.delegate = self
        openSlidingController(controller: cashOrTerminalViewController, height: 250)
    }
    func creditCardViewShow(){
        let creditCardTypeViewController = CreditCardTypeViewController()
        creditCardTypeViewController.delegate = self
        openSlidingController(controller: creditCardTypeViewController, height: 400)
    }
    
    private func openSlidingController(controller: UIViewController, height: CGFloat) {
        slide.height = height
        slide.direction = .bottom
        let vc = NavigationController.init(rootViewController: controller)
        vc.transitioningDelegate = slide
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    func deliveryAddressShow() {
        self.showSlideController()
    }
    
    func pickupAddressShow() {
        self.showSlideController(isPickup: true)
    }
    
    private func showSlideController(isPickup: Bool = false) {
        let bottomAddressViewController = BottomAddressViewController()
        bottomAddressViewController.delegate = self
        bottomAddressViewController.didSelectItem = { [weak self] selectedItem in
            guard let self = self else {return}
            self.dismiss(animated: true) {
                if let selectedItem = selectedItem as? EachAddress {
                    if let deliveryCell = self.deliveryView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormalizationDeliveryCell {
                        deliveryCell.streetLabel.attributedText = NSAttributedString.getAttrTextWith(15, selectedItem.address, false, UIColor(hex: "#848484", alpha: 1.0), .center)
                    }
                    
                } else if let selectedItem = selectedItem as? EachStore {
                    if let pickupAddressCell = self.pickupView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormalizationPickupCell {
                        pickupAddressCell.streetLabel.attributedText = NSAttributedString.getAttrTextWith(15, selectedItem.address ?? "", false, UIColor(hex: "#848484", alpha: 1.0), .center)
                        pickupAddressCell.placePhoneLabel.attributedText = NSAttributedString.getAttrTextWith(15, selectedItem.phoneNumber ?? "", false, UIColor(hex: "#000000", alpha: 0.6), .left)
                    }
                }
            }
        }
        if isPickup == false {
            bottomAddressViewController.data = CoreDataSyncManager.shared.fetchAdresses()
        } else {
            bottomAddressViewController.data = storeLocationList
        }
        let count = isPickup == false ? CoreDataSyncManager.shared.fetchAdresses().count : storeLocationList?.count ?? 1
        let height = count < 6 ? calculateSlideHeight(count: count) : calculateSlideHeight(count: 5)
        openSlidingController(controller: bottomAddressViewController, height: height)
    }
}

extension FormalizationViewController: SlidingAddressProtocol, PickupAddressDelegate, CashOrTerminalDelegate, CreditCardTypeDelegate {
    func cashOrTerminalChosen(name: String) {
        paymentTypeList?.map{ if ($0.name == name) {formalizationModel.paymentTypeId = $0.id }}
        if formalizationSwitcher.selectedSwitch == 1 {
            deliveryView.isCash = true
        } else {
            pickupView.isCash = true
        }
    }
    func creditCardTypeChosen() {
        if formalizationSwitcher.selectedSwitch == 1 {
            deliveryView.isCash = false
        } else {
            pickupView.isCash = false
        }
    }
    
    func didChooseFromMap() {
        self.perform(transition: YandexMapFormalizationController())
    }
    
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
        CoreDataSyncManager.shared.deleteAddress(by: id)
    }
    
    func openYandexMaps(isPickup: Bool) {
        let vc = YandexMapFormalizationController()
        vc.didSelectAdress = { [weak self] address in
            guard let self = self else {return}
            if let address = address as? EachAddress {
                self.setCoreDataAdresses(fromMaps: true, address: address)
            } else if let apiAdress = address as? EachStore {
                if let list = self.storeLocationList {
                    self.setApiAdress(list: list, selectedAddress: apiAdress)
                }
            }
            self.back(with: .pop)
        }
        if isPickup {
            if let locations = storeLocationList {
                vc.clusterPoints = getClusterPoints(data: locations)
                vc.data = locations
            }
        } else {
            let locations = CoreDataSyncManager.shared.fetchAdresses()
            vc.clusterPoints = getClusterPoints(data: locations)
            vc.data = locations
        }
        self.perform(transition: vc)
    }
    
    
}
