//
//  YandexMapController.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 05/07/22.
//

import Foundation
import YandexMapsMobile
import CoreLocation
import UIKit

class YandexMapController: BaseViewController, UIScrollViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, YMKMapCameraListener  {
    
    let locationManager = CLLocationManager()
    let slidingSearchView = YandexMapSearchView()
    var currentLocation: CLLocation?
    let requestModel = YandexGeocodeRequestModel()
    let mainScreenViewModel = MainScreenViewModel()
    var canMoveUp = true
    var canMoveDown = true
    var lat: Double?
    var lon: Double?
    var addressID: String?
    var isSearching = false
    var yPosition: CGFloat = 0.0
    var locationsArray = [YandexAddress]() {
        didSet {
            if !locationsArray.isEmpty {
                if isSearching == false {
                    slidingSearchView.searchTextField.text = locationsArray[0].name
                    slidingSearchView.confirmButton.setAttributedTitle(NSAttributedString.getAttrTextWith(15, "save".translate(), false, UIColor(hex: "#FFFFFF", alpha: 1.0)), for: .normal)
                    
                }
                self.collectionView.reloadData()
            }
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestModel.didAddAdress = { [weak self] data in
            guard let self = self else {return}
            if data.statusCode == 200 {
                self.back(with: .pop)
            }
        }
        requestModel.didReceiveAdresses = { [weak self] data in
            guard let self = self else {return}
            self.locationsArray = self.requestModel.adressArray
        }
        mainScreenViewModel.didUpdateAddressByID = { [weak self] responce in
            guard let self = self else {return}
            self.back(with: .pop)
        }
        slidingSearchView.confirmButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmButtonTapped)))
        mapView.mapWindow.map.addCameraListener(with: self)
        slidingSearchView.mapLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMapLabel)))
        slidingSearchView.searchTextField.addTarget(self, action: #selector(queryChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selfLocView.layer.cornerRadius = selfLocView.bounds.width / 2.0
        selfLocView.clipsToBounds = true
        selfLocView.setStyleWithShadow(cornerRadius: selfLocView.bounds.width / 2.0)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if canMoveUp {
            self.moveUp()
        }
    }
    @objc private func didTapMapLabel() {
        self.moveDown()
    }
    @objc private func selfPositionTapped() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    @objc func confirmButtonTapped() {
        
        if UD.token == nil {
            var address = EachAddress()
            address.address = slidingSearchView.searchTextField.text.notNullString
            address.latitude = lat ?? 0.0
            address.longitude = lon ?? 0.0
            let id = addressID != nil ? addressID : String(arc4random_uniform(1000) + 10)
            address.id =  id ?? ""
            address.createdAt = ""
            address.clientId = ""
            CoreDataSyncManager.shared.saveAddressToCoreData(model: address)
        } else {
            if addressID != nil {
                mainScreenViewModel.updateAddressById(id: addressID!, address: slidingSearchView.searchTextField.text.notNullString, lat: lat ?? 0.0, lon: lon ?? 0.0)
            } else {
                requestModel.addAdress(adress: slidingSearchView.searchTextField.text.notNullString, lat: lat ?? 0.0, lon: lon ?? 0.0)
            }
        }
        self.back(with: .pop)
        
    }
    
    var layout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collection.backgroundColor = .white
        collection.decelerationRate = .normal
        collection.clipsToBounds = true
        collection.layer.cornerRadius = 20
        collection.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collection.showsVerticalScrollIndicator = false
        collection.register(YandexAddressesViewCell.self, forCellWithReuseIdentifier: "AddressCellID")
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    @objc func queryChanged(_ sender: UITextField) {
        
        isSearching = true
        requestModel.requestGeocodeData(latlon: sender.text.notNullString)
    }
    
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateReason: YMKCameraUpdateReason,
                                 finished: Bool) {
        if finished {
            let latLon = "\(map.cameraPosition.target.longitude),\(map.cameraPosition.target.latitude)"
            self.lat = map.cameraPosition.target.latitude
            self.lon = map.cameraPosition.target.longitude
            self.isSearching = false
            requestModel.requestGeocodeData(latlon: latLon)
        }
    }
    
    lazy var mapView: YMKMapView = {
        let mv = YMKMapView()
        return mv
    }()
    
    lazy var pinImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage.init(named: "yandexPin")
        return im
    }()
    
    lazy var selfLocationImgV: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "selfLoc")
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    lazy var selfLocView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfPositionTapped)))
        return v
    }()
    
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        guard let senderView = gestureRecognizer.view else { return }
//        guard let parentView = senderView.superview else { return }
//        let translation = gestureRecognizer.translation(in: parentView)
//
//        if gestureRecognizer.state == .began {
//            yPosition = senderView.superview?.frame.minY ?? 0.0
//
//        }
//        if gestureRecognizer.state == .changed {
//            let newPos = CGPoint(x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + yPosition + translation.y)
//            if newPos.y > 100 * RatioCoeff.height && newPos.y < SCREEN_SIZE.height - 240 {
//                self.collectionView.frame = CGRect(x: 0, y: newPos.y, width: view.frame.width, height: self.view.safeAreaLayoutGuide.layoutFrame.height + 40.0)
//                parentView.layoutIfNeeded()
//            }
//
//
//
//        }
        
    }
    
    private func setupView() {
        view.addSubview(mapView)
        mapView.addSubview(pinImageView)
        mapView.addSubview(selfLocView)
        view.addSubview(collectionView)
        selfLocView.addSubview(selfLocationImgV)
        mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        pinImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 70, height: 70))
        pinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pinImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -35).isActive = true
        selfLocView.anchor(top: nil, leading: nil, bottom: mapView.bottomAnchor, trailing: mapView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 260, right: 20), size: CGSize(width: 48, height: 48))
        selfLocationImgV.anchor(top: selfLocView.topAnchor, leading: selfLocView.leadingAnchor, bottom: selfLocView.bottomAnchor, trailing: selfLocView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 13, bottom: 11, right: 13))
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        slidingSearchView.searchTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = CGRect(x: 0, y: SCREEN_SIZE.height - 240, width: SCREEN_SIZE.width, height: 240)
        view.addSubview(slidingSearchView)
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        slidingSearchView.isUserInteractionEnabled = true
//        slidingSearchView.addGestureRecognizer(gestureRecognizer)
        slidingSearchView.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.up
        self.slidingSearchView.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.down
        self.slidingSearchView.addGestureRecognizer(swipeLeft)
        slidingSearchView.resultLabel.isHidden = true
        slidingSearchView.anchor(top: collectionView.topAnchor, leading: collectionView.leadingAnchor, bottom: nil, trailing: collectionView.trailingAnchor, size: CGSize(width: view.frame.size.width, height: 220))
        self.slidingSearchView.mapLabel.isHidden = true
        self.slidingSearchView.separatorView.isHidden = true
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.up:
                    self.moveUp()
                case UISwipeGestureRecognizer.Direction.down:
                    self.moveDown()
                default:
                    break
                }
            }
        }
    
}



extension YandexMapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                cameraCallback: nil)
            if let lat = locations.last?.coordinate.latitude, let lon = locations.last?.coordinate.longitude {
                let latLon = "\(lon),\(lat)"
                self.isSearching = false
                requestModel.requestGeocodeData(latlon: latLon)
            }
        }
    }
}

extension YandexMapController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressCellID", for: indexPath) as! YandexAddressesViewCell
        cell.setItem(item: locationsArray[indexPath.row].name)
        cell.imageV.image = UIImage.init(named: "cycle")
        if indexPath.row != locationsArray.count - 1 {
            cell.layer.addBorder(edge: .bottom, color: Theme.current.headlinesColor.withAlphaComponent(0.08), thickness: 1)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.collectionView else {return}
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            //down
            if scrollView.isAtTop {
                self.moveDown()
            }
        } else {
            //up
            if canMoveUp {
                self.moveUp()
            }
        }
    }
    
    private func moveUp() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.collectionView.frame = CGRect(x: 0, y: 100 * RatioCoeff.height, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height - 100 * RatioCoeff.height)
            self.collectionView.setContentOffset(.zero, animated: false)
            self.slidingSearchView.resultLabel.isHidden = false
            self.slidingSearchView.confirmButton.isHidden = true
            self.slidingSearchView.mapLabel.isHidden = false
            self.slidingSearchView.separatorView.isHidden = false
            self.layout.sectionInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
            self.collectionView.reloadData()
            
            self.view.layoutIfNeeded()
            self.canMoveUp = false
        }
    }
    
    private func moveDown() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.collectionView.frame = CGRect(x: 0, y: SCREEN_SIZE.height - 240, width: SCREEN_SIZE.width, height: 240)
            self.slidingSearchView.resultLabel.isHidden = true
            self.slidingSearchView.confirmButton.isHidden = false
            self.slidingSearchView.mapLabel.isHidden = true
            self.slidingSearchView.separatorView.isHidden = true
            self.layout.sectionInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
            self.collectionView.reloadData()
            
            self.view.layoutIfNeeded()
            self.canMoveUp = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 35 * RatioCoeff.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.slidingSearchView.searchTextField.text = locationsArray[indexPath.row].name
        self.slidingSearchView.searchTextField.resignFirstResponder()
        self.moveDown()
        
        if let latitude = locationsArray[indexPath.row].loc.components(separatedBy: " ").last, let longitude = locationsArray[indexPath.row].loc.components(separatedBy: " ").first {
            if let lat = Double(String(latitude)), let long = Double(String(longitude)) {
                mapView.mapWindow.map.move(
                    with: YMKCameraPosition.init(target: YMKPoint(latitude: lat, longitude: long), zoom: 15, azimuth: 0, tilt: 0),
                    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                    cameraCallback: nil)
            }
        }
    }
}


