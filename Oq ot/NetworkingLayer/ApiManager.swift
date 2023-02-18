//
//  ApiManager.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 05/03/22.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol APIManagerDelegate: AnyObject {
    func requestDidFinish(with response: Any, method: String, HTTPMethod: HTTPMethod)
}

class APIManager {
    static let shared = APIManager()
    var sessionManagerProxy = SessionManager()
    
    func request(with parameters: Endpoint,
                 userInfo: Params? = nil,
                 delegate: APIManagerDelegate?) {
        if jsonLog {
            logRequest(headers: parameters.headers(), httpMethod: parameters.method(), parameters: parameters.parameters())
        }
        try? sessionManagerProxy.request(with: parameters,
                                         responseJSON: { response in
            if jsonLog {
                self.logResponse(response: response)
            }
            
//            if parameters.method() == ApiEndpoints.getMainScreenGoods {
//                self.logResponse(response: response)
//            }
           
            delegate?.requestDidFinish(with: response, method: parameters.method(), HTTPMethod: parameters.httpMethod())
            
        })
        
        
    }
    
    func cancelRequest() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func logRequest(headers: HTTPHeaders,
                    httpMethod: String,
                    parameters: Parameters?) {
        
        debugPrint("SEND: >>>>")
        debugPrint(JSON(headers))
        debugPrint("************* JSON SENT \(httpMethod) *************")
        debugPrint(JSON(parameters as Any))
        debugPrint("*************************************")
    }
    
    func logResponse(response: DataResponseWrapper) {
      
        var responseResult: Any = ""
        if let error = response.resultError {
            responseResult = error.localizedDescription
        } else {
            responseResult = response.resultValue ?? ""
        }
        
        debugPrint("\(Date())")
        debugPrint("RECEIVE: <<<<")
        debugPrint("************* JSON RECEIVED *************")
        debugPrint(JSON(responseResult))
        debugPrint("*************************************")
    }
    
}

