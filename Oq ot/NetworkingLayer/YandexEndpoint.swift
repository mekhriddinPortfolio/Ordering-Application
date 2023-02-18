//
//  YandexEndpoint.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 17/07/22.
//

import Foundation
import Alamofire

enum YandexEndpoint: Endpoint {
   
    case requestGeolocation(latlon: String)
    case addAdress(adress: String, lat: Double, lon: Double)
   
    
    func parameters() -> Params? {
        switch self {
        case let .requestGeolocation(latlon):
            var params = Params()
            params.updateAny(latlon, forKey: "geocode")
            return params
        case let .addAdress(adress, lat, lon):
            var params = Params()
            params.updateAny(adress, forKey: "address")
            params.updateAny(lat, forKey: "latitude")
            params.updateAny(lon, forKey: "longitude")
            return params
            
        }
    }
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .addAdress:
            return .post
        default:
            return .get

        }
    }
    
    func headers() -> HTTPHeaders {
        switch self {
        case .addAdress:
            var headers = Headers()
            headers.updateValue("application/json", forKey: "accept")
            if let token = UD.token {
                headers.updateValue("Bearer \(token)", forKey: "Authorization")
            }
            
            return headers
        default:
           return Headers()
        }
    }
   
    func method() -> String {
        switch self {
        case .addAdress:
            return ApiEndpoints.getAdressList
        case .requestGeolocation:
            return ApiEndpoints.yandexRequest
            
        }
        
    }
  
}
