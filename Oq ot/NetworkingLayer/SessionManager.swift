//
//  SessionManager.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 05/03/22.
//

import Alamofire

class SessionManager {

    func request(with parameters: Endpoint, responseJSON: @escaping (DataResponseWrapper) -> Void) throws {
        Alamofire.request(try parameters.asURLRequest())
            .responseJSON { response in
                responseJSON(DataResponseWrapper(dataResponse: response))
            }
    }
}

class DataResponseWrapper {
    var resultValue: Any?
    var resultError: Error?
    var statusCode: Int?
    var data: Data?
   
    
    init(dataResponse: DataResponse<Any>) {
        resultValue = dataResponse.result.value
        resultError = dataResponse.result.error
        statusCode = dataResponse.response?.statusCode
        data = dataResponse.data
    }
}
