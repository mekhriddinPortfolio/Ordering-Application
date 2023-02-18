//
//  YandexGeocodeRequestModel.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 17/07/22.
//

import Foundation
import Alamofire
class YandexGeocodeRequestModel: APIManagerDelegate {
    
    var adressArray = [YandexAddress]()
    var didReceiveAdresses: ((_ result: DataResponseWrapper) -> Void)?
    var didAddAdress: ((_ result: DataResponseWrapper) -> Void)?
    
    
    func requestDidFinish(with response: Any, method: String, HTTPMethod: HTTPMethod) {
        guard let response = response as? DataResponseWrapper  else {return}
        if method == ApiEndpoints.yandexRequest {
            var tempAddressArray = [YandexAddress]()
            guard let resultField = (response.resultValue as? Params)?["response"] else {return}
            
            if let objectCollection = (resultField as? Params)?["GeoObjectCollection"] {
                if let member = (objectCollection as? Params)?["featureMember"] {
                    for i in member as! [Params] {
                        if let geoObject = (i as? Params)?["GeoObject"] {
                            if let metaDataProperty = (geoObject as? Params)?["name"], let location = (geoObject as? Params)?["Point"] as? Params{
                                if let GeocoderMetaData = (metaDataProperty as? String), let position = (location["pos"] as? String) {
                                    tempAddressArray.append(YandexAddress(name: GeocoderMetaData, loc: position))
                                }
                            }
                        }
                    } // end of for loop
                    adressArray = tempAddressArray
                    didReceiveAdresses?(response)
                }
            }
            
        }
        
        if method == ApiEndpoints.getAdressList {
            didAddAdress?(response)
        }
    }
    
    func requestGeocodeData(latlon:String) {
        APIManager.shared.request(with: YandexEndpoint.requestGeolocation(latlon: latlon), delegate: self)
    }
    
    func addAdress(adress:String, lat: Double, lon: Double) {
        APIManager.shared.request(with: YandexEndpoint.addAdress(adress: adress, lat: lat, lon: lon), delegate: self)
    }
    
    
}

struct YandexAddress {
    let name: String
    let loc: String
}
