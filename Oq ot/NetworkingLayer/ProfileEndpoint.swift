//
//  ProfileEndpoint.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 27/07/22.
//

import Foundation

import Foundation
import Alamofire

enum ProfileEndPoints: Endpoint {
    
    case getUserProfile
    case updateUserProfile(login: String, firstName: String, lastName: String, middleName: String, sex: Int, password: String, birthday: String, avatarPhotoPath: String, id: String)
    case addCard(name: String, cardNumber: String, dateOfIssue: String)
    case getCardList
    case getAddressList
    case updateAddressById(id: String, address: String, lat: Double, lon: Double)
    case deleteAddressById(id: String)
    case getChatUsers
    case getChatMessages(id: String, pageIndex: Int, pageSize: Int)
    case getOrderHistory(pageIndex: Int, pageSize: Int)
    
    func parameters() -> Params? {
        switch self {
        case .getUserProfile:
            return Params()
        case let .updateUserProfile(login, firstName, lastName, middleName, sex, password, birthday, avatarPhotoPath, id):
            var params = Params()
            params.updateAny(login, forKey: "login")
            params.updateAny(firstName, forKey: "firstName")
            params.updateAny(lastName, forKey: "lastName")
            params.updateAny(middleName, forKey: "middleName")
            params.updateAny(sex, forKey: "sex")
            params.updateAny(password, forKey: "password")
            params.updateAny(birthday, forKey: "birthday")
            params.updateAny(avatarPhotoPath, forKey: "avatarPhotoPath")
            params.updateAny(id, forKey: "id")
            return params
        case let .addCard(name, cardNumber, dateOfIssue):
            var params = Params()
            params.updateAny(name, forKey: "name")
            params.updateAny(cardNumber, forKey: "cardNumber")
            params.updateAny(dateOfIssue, forKey: "dateOfIssue")
            return params
        case .getCardList:
            return Params()
        case .getAddressList:
            return Params()
        case let .updateAddressById(id, address, lat, lon):
            var params = Params()
            params.updateAny(id, forKey: "id")
            params.updateAny(address, forKey: "address")
            params.updateAny(lat, forKey: "latitude")
            params.updateAny(lon, forKey: "longitude")
            return params
        case let .deleteAddressById(id):
            var params = Params()
            params.updateAny(id, forKey: "id")
            return params
        case .getChatUsers:
            return Params()
        case .getChatMessages(_, _, _):
            return Params()
        case .getOrderHistory(_, _):
            return Params()
        }
    }

     func httpMethod() -> HTTPMethod {
         switch self {
         case .getUserProfile, .getCardList, .getAddressList, .getChatUsers, .getChatMessages, .getOrderHistory:
             return .get
         case .updateAddressById, .updateUserProfile:
             return .put
         case .deleteAddressById:
             return .delete
         default:
             return .post
         }
     }
     
     func headers() -> HTTPHeaders {
         switch self {
         case .getUserProfile, .updateUserProfile, .addCard, .getCardList, .getAddressList, .updateAddressById, .deleteAddressById, .getChatUsers, .getChatMessages, .getOrderHistory:
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
        case .getUserProfile, .updateUserProfile:
            return ApiEndpoints.getUserProfile
        case .addCard, .getCardList:
            return ApiEndpoints.addCard
        case .getAddressList, .updateAddressById, .deleteAddressById:
            return ApiEndpoints.getAdressList
        case .getChatUsers:
            return ApiEndpoints.getChatUsers
        case let .getChatMessages(id, pageIndex, pageSize):
            return ApiEndpoints.getChatMessages.replacingOccurrences(of: "!", with: id).replacingOccurrences(of: "@", with: "\(pageIndex)").replacingOccurrences(of: "#", with: "\(pageSize)")
        case let .getOrderHistory(pageIndex, pageSize):
            return ApiEndpoints.getOrderHistory.replacingOccurrences(of: "@", with: "\(pageIndex)").replacingOccurrences(of: "#", with: "\(pageSize)")
        }
    }
}

