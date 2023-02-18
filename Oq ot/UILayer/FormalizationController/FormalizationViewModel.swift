//
//  FormalizationViewModel.swift
//  Oq ot
//
//  Created by AvazbekOS on 21/08/22.
//

import Foundation
import Alamofire


class FormalizationViewModel: APIManagerDelegate {
    
    var didSendFormalization: ((_ result: DataResponseWrapper?, _ error: Error?) -> Void)?
    var didGetListOfStores: ((_ result: ListOfStores?, _ error: Error?) -> Void)?
    var listOfStores: ListOfStores?
    var didGetListOfPaymentTypes: ((_ result: ListOfPaymentTypes?, _ error: Error?) -> Void)?
    var listOfPaymentTypes: ListOfPaymentTypes?
    func requestDidFinish(with response: Any, method: String, HTTPMethod: HTTPMethod) {
        guard let response = response as? DataResponseWrapper else {return}
        switch method {
        case ApiEndpoints.sendFormalizationDetails:
            if response.resultError == nil {
                didSendFormalization?(response, nil)
            } else {
                didSendFormalization?(nil, response.resultError)
            }
        case ApiEndpoints.getListOfStores:
            do {
                listOfStores = try JSONDecoder().decode(ListOfStores.self, from: response.data!)
                didGetListOfStores?(listOfStores, nil)
            } catch {
                didGetListOfStores?(nil, error)
            }
        case ApiEndpoints.getListOfPaymentTypes:
            do {
                listOfPaymentTypes = try JSONDecoder().decode(ListOfPaymentTypes.self, from: response.data!)
                didGetListOfPaymentTypes?(listOfPaymentTypes, nil)
            } catch {
                didGetListOfPaymentTypes?(nil, error)
            }
        default:
            break
        }
    }

    func sendFormalizationDetails(formalizationModel: FormalizationModel) {
        APIManager.shared.request(with: FormalizationEndpoint.sendDetails(formalizationModel: formalizationModel), delegate: self)
    }
    
    func getListOfStores() {
        APIManager.shared.request(with: FormalizationEndpoint.getListOfStores, delegate: self)
    }
    
    func getPaymentTypes() {
        APIManager.shared.request(with: FormalizationEndpoint.getListOfPaymentTypes, delegate: self)
    }
    
}

