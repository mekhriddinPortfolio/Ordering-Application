//
//  YandexMapsLocationsView.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 23/07/22.
//

import UIKit
import YandexMapsMobile

class YandexMapsLocationsView: UIView {
 
    var clusterPoints: [YMKPoint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var mapView: YMKMapView = {
        let mv = YMKMapView()
        return mv
    }()
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(mapView)
        mapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    func addPins() {
        if clusterPoints.isEmpty == false {
            let cameraPosition = YMKCameraPosition(
                target: clusterPoints[0], zoom: 8, azimuth: 0, tilt: 0)
            mapView.mapWindow.map.move(with: cameraPosition)
            let collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)

            let points = clusterPoints
            collection.addPlacemarks(with: points, image: UIImage(named: "cluster")!, style: YMKIconStyle())
            collection.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
        }
     
    }
}


extension YandexMapsLocationsView: YMKMapObjectTapListener, YMKClusterListener, YMKClusterTapListener {
    
    func onClusterTap(with cluster: YMKCluster) -> Bool {
        return true
    }
    
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(Utils.clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let userPoint = mapObject as? YMKPlacemarkMapObject else {
            return true
        }
        
        return false
    }
    
}
