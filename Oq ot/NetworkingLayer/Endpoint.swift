//
//  Endpoint.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 05/03/22.
//

import Foundation
import Alamofire

typealias Params = Parameters
typealias Headers = HTTPHeaders

protocol Endpoint: URLRequestConvertible {
    func parameters() -> Parameters?
    func method() -> String
    func httpMethod() -> HTTPMethod
    func headers() -> HTTPHeaders
}
extension Endpoint {
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.queryString
        }
    }
    
    func headers() -> HTTPHeaders {
        switch self {
        default:
            var headers = Headers()
//            headers.updateValue("application/json; charset=utf-8", forKey: "Content-Type")
            return headers
         
        }
    }

    
    public func asURLRequest() throws -> URLRequest {
        let url = try method().asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod().rawValue
        switch method() {
        case ApiEndpoints.sendValidationCode, ApiEndpoints.verifyPhoneNumber, ApiEndpoints.register, ApiEndpoints.sendFormalizationDetails:
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters()!, options: [])
        default:
            break
        }
        
        if method() == ApiEndpoints.getAdressList && (httpMethod() == .put || httpMethod() == .post) {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters()!, options: [])
        }
        
        if method() == ApiEndpoints.addCard && (httpMethod() == .put || httpMethod() == .post) {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters()!, options: [])
        }
        if method() == ApiEndpoints.getUserProfile && httpMethod() == .put {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters()!, options: [])
        }
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.allHTTPHeaderFields = headers()
        urlRequest.timeoutInterval = 30
        urlRequest = try encoding.encode(urlRequest, with: parameters())
        return urlRequest
    }
}


