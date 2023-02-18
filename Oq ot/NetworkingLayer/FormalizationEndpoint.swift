//
//  FormalizationEndpoint.swift
//  Oq ot
//
//  Created by AvazbekOS on 21/08/22.
//

import Foundation
import Alamofire

enum FormalizationEndpoint: Endpoint {
    case sendDetails(formalizationModel: FormalizationModel)
    case getListOfStores
    case getListOfPaymentTypes
    
    func parameters() -> Params? {
        switch self {
        case let .sendDetails(formalizationModel):
            var params = Params()
            params.updateAny(formalizationModel.comment, forKey: "comment")
            params.updateAny(formalizationModel.dontCallWhenDelivered, forKey: "dontCallWhenDelivered")
            params.updateAny(formalizationModel.destinationType, forKey: "destinationType")
            params.updateAny(formalizationModel.floor, forKey: "floor")
            params.updateAny(formalizationModel.entrance, forKey: "entrance")
            let lat = formalizationModel.isPickup ? formalizationModel.toLatitudeForPickup : formalizationModel.toLatitude
            let lon = formalizationModel.isPickup ? formalizationModel.toLongitudeForPickup : formalizationModel.toLongitude
            params.updateAny(lon, forKey: "toLongitude")
            params.updateAny(lat, forKey: "toLatitude")
            params.updateAny(formalizationModel.isPickup, forKey: "isPickup")
            params.updateAny(formalizationModel.paymentTypeId, forKey: "paymentTypeId")
            params.updateAny(formalizationModel.promo, forKey: "promo")
            params.updateAny(formalizationModel.goods, forKey: "goodToOrders")
            if let deliveryTime = formalizationModel.deliverAt {
                params.updateAny(deliveryTime, forKey: "deliverAt")
            }
            return params
        case .getListOfStores:
            return Params()
        case .getListOfPaymentTypes:
            return Params()
        }
    }
    
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .getListOfStores, .getListOfPaymentTypes:
            return .get
        default:
            return .post

        }
    }
    
    func headers() -> HTTPHeaders {
        switch self {
        case .getListOfStores, .getListOfPaymentTypes, .sendDetails:
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
        case .sendDetails:
            return ApiEndpoints.sendFormalizationDetails
        case .getListOfStores:
            return ApiEndpoints.getListOfStores
        case .getListOfPaymentTypes:
            return ApiEndpoints.getListOfPaymentTypes
        }
    }
}
