//
//  YandexMapFormalizationController.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 23/07/22.
//


import Foundation
import YandexMapsMobile
import CoreLocation

class YandexMapFormalizationController: BaseViewController, UIScrollViewDelegate, UICollectionViewDelegate, YMKMapCameraListener, YMKClusterListener, YMKClusterTapListener {
 
    let slidingSearchView = YandexMapPickupView()
    var scrollView = UIScrollView(frame: .zero)
    var currentLocation: CLLocation?
    var canMoveUp = true
    var canMoveDown = true
    var clusterPoints: [YMKPoint] = []
    var data: [Any] = []
    var didSelectAdress: ((_ address: Any) -> Void)?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.insertSubview(scrollView, aboveSubview: mapView)
        scrollView.addSubview(slidingSearchView)
        mapView.mapWindow.map.addCameraListener(with: self)
        configScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if clusterPoints.isEmpty == false {
            addPins()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selfLocView.layer.cornerRadius = selfLocView.bounds.width / 2.0
        selfLocView.clipsToBounds = true
        selfLocView.setStyleWithShadow(cornerRadius: selfLocView.bounds.width / 2.0)
    }
    
    private func addPins() {
        let cameraPosition = YMKCameraPosition(
            target: clusterPoints[0], zoom: 8, azimuth: 0, tilt: 0)
        mapView.mapWindow.map.move(with: cameraPosition)
        let collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        collection.addTapListener(with: self)
        let points = clusterPoints
        collection.addPlacemarks(with: points, image: UIImage(named: "cluster")!, style: YMKIconStyle())
        collection.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
    }
    
    private func configScrollView() {
        scrollView.frame = CGRect(x: 0, y: SCREEN_SIZE.height - SCREEN_SIZE.height/4, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height/4)
        scrollView.backgroundColor = .clear
        slidingSearchView.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height/4)
        scrollView.layer.cornerRadius = 15
        slidingSearchView.layer.cornerRadius = 15
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height + 1)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.decelerationRate = .normal
        scrollView.bounces = false
     
    }
    
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        print("kk")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            if canMoveDown {
                self.moveDown()
            }
           } else {
               if canMoveUp {
                   self.moveUp()
               }
           }
    }
    
    private func moveUp() {
        self.canMoveUp = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.scrollView.frame = CGRect(x: 0, y: 100, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height - 100)
            self.slidingSearchView.frame = CGRect(x: 0, y: 100, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height - 100)
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height + 1)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 1), animated: false)
                self.view.layoutIfNeeded()
                self.canMoveDown = true
            }
        }
    }
    
    
    private func moveDown() {
        self.canMoveDown = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.scrollView.frame = CGRect(x: 0, y: SCREEN_SIZE.height - SCREEN_SIZE.height/4, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height/4)
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height + 1)
            self.slidingSearchView.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height/4)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.view.layoutIfNeeded()
                self.canMoveUp = true
            }
        }
    }
    
    func onClusterAdded(with cluster: YMKCluster) {
        // We setup cluster appearance and tap handler in this method
        cluster.appearance.setIconWith(Utils.clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }

    func onClusterTap(with cluster: YMKCluster) -> Bool {
        return true
    }

    lazy var mapView: YMKMapView = {
        let mv = YMKMapView()
        return mv
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
//        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfPositionTapped)))
        return v
    }()
  
    private func setupView() {
        view.addSubview(mapView)
        mapView.addSubview(selfLocView)
        selfLocView.addSubview(selfLocationImgV)
        mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        selfLocView.anchor(top: nil, leading: nil, bottom: mapView.bottomAnchor, trailing: mapView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: SCREEN_SIZE.height/4 + 20, right: 20), size: CGSize(width: 48, height: 48))
        selfLocationImgV.anchor(top: selfLocView.topAnchor, leading: selfLocView.leadingAnchor, bottom: selfLocView.bottomAnchor, trailing: selfLocView.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 13, bottom: 11, right: 13))
        
        slidingSearchView.collectionView.delegate = self
        slidingSearchView.collectionView.dataSource = self
        
    }
    
}


extension YandexMapFormalizationController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: YandexAddressesViewCell.self), for: indexPath) as! YandexAddressesViewCell
        if let data = data as? [EachAddress] {
            cell.setItem(item: data[indexPath.row].address)
        } else if let apiData = data as? [EachStore] {
            cell.setItem(item: apiData[indexPath.row].address ?? "")
        }
        
        cell.isUserInteractionEnabled = true
        cell.imageV.image = UIImage(named: "EmptyCircle")
        cell.layer.addBorder(edge: .bottom, color: UIColor(hex: "#F2F2F2"), thickness: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - (2*16), height: 40 * RatioCoeff.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YandexAddressesViewCell {
            cell.imageV.image = UIImage(named: "CheckmarkCircle")
        }
        
        didSelectAdress?(data[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? YandexAddressesViewCell {
            cell.imageV.image = UIImage(named: "EmptyCircle")
        }
    }
}

extension YandexMapFormalizationController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let userPoint = mapObject as? YMKPlacemarkMapObject else {
            return true
        }
        
        let long = userPoint.geometry.longitude
        if let data = data as? [EachAddress] {
            let filteredData = data.filter {$0.longitude == long}
            if filteredData.isEmpty == false {
                didSelectAdress?(filteredData[0])
            }
           
        } else if let apiData = data as? [EachStore] {
            let filteredData = apiData.filter {$0.longitude == long}
            if filteredData.isEmpty == false {
                didSelectAdress?(filteredData[0])
            }
        }
        return false
    }
}



