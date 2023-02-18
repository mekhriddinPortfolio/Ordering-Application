//
//  AuthRequestModel.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 17/07/22.
//

import Foundation
import Alamofire

class AuthRequestModel: APIManagerDelegate {
    
    var didRegister: ((_ result: DataResponseWrapper?, _ error: Error?) -> Void)?
    var didSendValidationCode: ((_ result: DataResponseWrapper?, _ error: Error?) -> Void)?
    var didVerifyPhoneNumber: ((_ result: DataResponseWrapper?, _ error: Error?) -> Void)?
    
    func requestDidFinish(with response: Any, method: String, HTTPMethod: HTTPMethod) {
        guard let response = response as? DataResponseWrapper  else {return}
        switch method {
        case ApiEndpoints.register:
//            if response.resultError != nil {
                didRegister?(response, nil)
//            } else {
//                didRegister?(nil, response.resultError)
//            }
        case ApiEndpoints.sendValidationCode:
//            if response.resultError != nil {
                didSendValidationCode?(response, nil)
//            } else {
//                didSendValidationCode?(nil, response.resultError)
//            }
        case ApiEndpoints.verifyPhoneNumber:
//            if response.resultError != nil {
                didVerifyPhoneNumber?(response, nil)
//            } else {
//                didVerifyPhoneNumber?(nil, response.resultError)
//            }
        default:
            print("kk")
        }
    }
    
    
    func registerUser(phoneNumber: String, firstName: String, lastName: String, middleName: String, sex: Int, password: String, birthday: String, avatarPhotoPath: String) {
        APIManager.shared.request(with: AuthEndpoint.register(phoneNumber: phoneNumber,  firstName: firstName, lastName: lastName, middleName: middleName, sex: sex, password: password, birthday: birthday, avatarPhotoPath: avatarPhotoPath), delegate: self)
    }
    
    func sendValidationNumber(phoneNumber: String) {
        APIManager.shared.request(with: AuthEndpoint.sendValidationCode(phoneNumber: phoneNumber), delegate: self)
    }
    
    func verifyPhoneNumber(verificationCode: String, phoneNumber: String) {
        APIManager.shared.request(with: AuthEndpoint.verifyPhoneNumber(verificationCode: verificationCode, phoneNumber: phoneNumber), delegate: self)
    }
    
    
    
    
}
