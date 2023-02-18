//
//  MainScreenEndpoint.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 21/07/22.
//

import Foundation
import Alamofire

enum MainScreenEndpoint: Endpoint {
   
    case getCategories
    case getDiscountedGoods(page: Int)
    case sendValidationCode(phoneNumber: String)
    case getAddressList
    case updateAddressById(id: String, address: String, lat: Double, lon: Double)
    case getGoodsByCatID(catID: String)
    case deleteAddressById(id: String)
    case getMainScreenGoodCategories
    case getPagedgoodsBySubCatId(id: String, pageNumber: String)
    case searchGoods(queryString: String, page: String)
    
   
    func parameters() -> Params? {
        switch self {
        case .getCategories:
            return Params()
        case .getDiscountedGoods:
            return Params()
        case let .sendValidationCode(phoneNumber):
            var params = Params()
            params.updateAny(phoneNumber, forKey: "phoneNumber")
            return params
        case .getAddressList:
            return Params()
        case let .updateAddressById(id, address, lat, lon):
            var params = Params()
            params.updateAny(id, forKey: "id")
            params.updateAny(address, forKey: "address")
            params.updateAny(lat, forKey: "latitude")
            params.updateAny(lon, forKey: "longitude")
            return params
        case .getGoodsByCatID:
            return Params()
        case let .deleteAddressById(id):
            var params = Params()
            params.updateAny(id, forKey: "id")
            return params
        case .getMainScreenGoodCategories:
            return Params()
        case .getPagedgoodsBySubCatId:
            return Params()
        case .searchGoods:
            return Params()
        }
    }
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .getCategories, .getDiscountedGoods, .getAddressList, .getGoodsByCatID, .getMainScreenGoodCategories, .getPagedgoodsBySubCatId, .searchGoods:
            return .get
        case .updateAddressById:
            return .put
        case .deleteAddressById:
            return .delete
        default:
            return .post

        }
    }
    
    func headers() -> HTTPHeaders {
        switch self {
        case .getAddressList, .updateAddressById, .deleteAddressById:
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
        case .getCategories:
            return ApiEndpoints.getCategory
        case let .getDiscountedGoods(page):
            return ApiEndpoints.getDiscountedGoods.replacingOccurrences(of: "#", with: String(page))
        case .sendValidationCode:
            return ApiEndpoints.sendValidationCode
        case .getAddressList, .updateAddressById:
            return ApiEndpoints.getAdressList
        case let .deleteAddressById(id):
            return ApiEndpoints.deleteAdressList.replacingOccurrences(of: "#", with: id)
        case let .getGoodsByCatID(catID):
            return ApiEndpoints.getGoodsByID.replacingOccurrences(of: "#", with: catID)
        case .getMainScreenGoodCategories:
            return ApiEndpoints.getMainScreenGoods
        case let .getPagedgoodsBySubCatId(id, page):
            return ApiEndpoints.getPagedgoodsBySubCatId.replacingOccurrences(of: "#", with: id).replacingOccurrences(of: "@", with: page)
        case let .searchGoods(queryString, page):
            return ApiEndpoints.searchGoods.replacingOccurrences(of: "#", with: queryString).replacingOccurrences(of: "%", with: page)
        }
        
    }
  
}
