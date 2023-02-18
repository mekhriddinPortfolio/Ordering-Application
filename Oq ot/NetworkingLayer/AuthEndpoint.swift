//
//  AuthEndpoint.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 05/03/22.
//

import Foundation
import Alamofire

enum AuthEndpoint: Endpoint {
    
    
   
    case register(phoneNumber: String, firstName: String, lastName: String, middleName: String, sex: Int, password: String, birthday: String, avatarPhotoPath: String)
    case sendValidationCode(phoneNumber: String)
    case verifyPhoneNumber(verificationCode: String, phoneNumber: String)
   
    
  
    
    func parameters() -> Params? {
        switch self {
        case let .register(phoneNumber, firstName, lastName, middleName, sex, password, birthday, avatarPhotoPath):
            var params = Params()
            params.updateAny(phoneNumber, forKey: "phoneNumber")
            params.updateAny(firstName, forKey: "firstName")
            params.updateAny(lastName, forKey: "lastName")
            params.updateAny(middleName, forKey: "middleName")
            params.updateAny(sex, forKey: "sex")
            params.updateAny(password, forKey: "password")
            params.updateAny(birthday, forKey: "birthday")
            params.updateAny(avatarPhotoPath, forKey: "avatarPhotoPath")
            return params
            
        case let .sendValidationCode(phoneNumber):
            var params = Params()
            params.updateAny(phoneNumber, forKey: "phoneNumber")
            return params
        case let .verifyPhoneNumber(verificationCode, phoneNumber):
            var params = Params()
            params.updateAny(verificationCode, forKey: "verificationCode")
            params.updateAny(phoneNumber, forKey: "phoneNumber")
            return params
        }
    }
    
    func httpMethod() -> HTTPMethod {
        switch self {
        default:
            return .post

        }
    }
    
    func headers() -> HTTPHeaders {
        switch self {
        default:
           return Headers()
        }
    }
   
    func method() -> String {
        switch self {
        case .register:
            return ApiEndpoints.register
        case .sendValidationCode:
            return ApiEndpoints.sendValidationCode
        case .verifyPhoneNumber:
            return ApiEndpoints.verifyPhoneNumber
        }
        
    }
  
}
