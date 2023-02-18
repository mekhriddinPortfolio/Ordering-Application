//
//  DeliveryView.swift
//  Oq ot
//
//  Created by AvazbekOS on 03/08/22.
//

import UIKit

protocol DeliveryProtocol: AnyObject {
    func deliveryAddressShow()
    func promoCodeViewShow()
    func techSupportViewShow()
    func cashViewShow()
    func creditCardViewShow()
    
//    func kvOrOfficeViewShow()
    func didEndEntringEntrance(entrance text: String?)
    func didEndEntringFloor(floor text: String?)
    func didEndEntringKv(kv text: String?)
    
    func didEndCommiting(comment text: String)
    func didEndChosingTime(date text: String)
    func openYandexMaps(isPickup: Bool)
}


class DeliveryView: UIView, FormalizationDeliveryCellProtocol, FormalizationCellProtocol {

    weak var delegate: DeliveryProtocol?
    var isCash: Bool? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var isCalling: Bool = false {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var count: Int?
    var summary: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
        registerKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deliveryAddressViewTapped() {
        delegate?.deliveryAddressShow()
    }
    
    @objc private func yandexMapPressed() {
        delegate?.openYandexMaps(isPickup: false)
    }
    
//    @objc private func kvOrOfficeViewShow() {
//        delegate?.kvOrOfficeViewShow()
//    }
    
    func didEndEntringEntrance(entrance text: String?) {
        delegate?.didEndEntringEntrance(entrance: text)
    }
    
    func didEndEntringFloor(floor text: String?) {
        delegate?.didEndEntringFloor(floor: text)
    }
    
    func didEndEntringKv(kv text: String?) {
        delegate?.didEndEntringKv(kv: text)
    }
    
    @objc private func callingViewTapped() {
        isCalling.toggle()
    }
    
    func didEndCommiting(comment text: String) {
        delegate?.didEndCommiting(comment: text)
    }
    
    func didEndChosingTime(date text: String) {
        delegate?.didEndChosingTime(date: text)
    }
    
//    @objc private func kvOrOfficeViewTapped() {
//        delegate?.kvOrOfficeViewShow()
//    }
    @objc private func promoViewTapped() {
        delegate?.promoCodeViewShow()
    }
    @objc private func techSupportViewTapped() {
        delegate?.techSupportViewShow()
    }
    @objc private func cashViewTapped() {
        delegate?.cashViewShow()
    }
    @objc private func creditCardViewTapped() {
        delegate?.creditCardViewShow()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 80 - safeAreaInsets.bottom, right: 0)
    }

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.register(FormalizationDeliveryCell.self, forCellWithReuseIdentifier: String(describing: FormalizationDeliveryCell.self))
        collection.register(FormalizationPickupCell.self, forCellWithReuseIdentifier: String(describing: FormalizationPickupCell.self))
        collection.register(FormalizationCell.self, forCellWithReuseIdentifier: String(describing: FormalizationCell.self))
        collection.delegate = self
        collection.dataSource = self
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

}

extension DeliveryView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 // for fomalizationDeliveryCell, fomalizationPickupCell, and fomalizationCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FormalizationDeliveryCell.self), for: indexPath) as! FormalizationDeliveryCell
            cell.delegate = self
            if isCalling {
                cell.callingView.backgroundColor = UIColor(hex: "#5CCD34")
                cell.callingImage.isHidden = false
            } else {
                cell.callingView.backgroundColor = Theme.current.blackColor.withAlphaComponent(0.06) 
                cell.callingImage.isHidden = true
            }
            cell.numberMapImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliveryAddressViewTapped)))
            cell.countMapImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deliveryAddressViewTapped)))
            cell.yandexMapsLocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yandexMapPressed)))
//            cell.kvView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kvOrOfficeViewTapped)))
            cell.callingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callingViewTapped)))
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FormalizationCell.self), for: indexPath) as! FormalizationCell
            cell.delegate = self
            if isCash != nil {
                if isCash! {
                    cell.creditCardView.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.4).cgColor
                    cell.cashView.layer.borderColor = UIColor(hex: "#FF4000", alpha: 1.0).cgColor
                } else {
                    cell.cashView.layer.borderColor = UIColor(hex: "#FF4000", alpha: 0.4).cgColor
                    cell.creditCardView.layer.borderColor = UIColor(hex: "#FF4000", alpha: 1.0).cgColor
                }
            }
            cell.promoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promoViewTapped)))
            cell.techSupportView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(techSupportViewTapped)))
            cell.setOrderSummaryData(count: count ?? 0, summaryPrice: summary ?? "")
            cell.cashView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cashViewTapped)))
            cell.creditCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(creditCardViewTapped)))
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: SCREEN_SIZE.width, height: 533)
        case 1:
            return CGSize(width: SCREEN_SIZE.width, height: 1200)
        default:
            break
        }
        return CGSize(width: 0, height: 0)
    }
    
}
