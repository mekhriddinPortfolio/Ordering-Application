//
//  ProfileViewModel.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 27/07/22.
//

import Foundation
import Alamofire

class ProfileViewModel: APIManagerDelegate {
    
    var didGetUserProfile: ((_ result: ProfileInfoModel?, _ error: Error?) -> Void)?
    var didUpdateUserProfile: (( _ responce: DataResponseWrapper?) -> Void)?
    var profileInfo: ProfileInfoModel?
    
    var didGetCardList: ((_ result: CardList?, _ error: Error?) -> Void)?
    var didAddCard: ((_ result: DataResponseWrapper?, _ error: Error?) -> Void)?
    var cardList: CardList?

    var didGetAddressList: ((_ result: AddressList?, _ error: Error?) -> Void)?
    var didUpdateAddressByID: (( _ responce: DataResponseWrapper?) -> Void)?
    var didDeleteAddressByID: (( _ responce: DataResponseWrapper?) -> Void)?
    
    var didGetChatUsers: ((_ result: ChatUsersList?, _ error: Error?) -> Void)?
    var didGetChatMessages: ((_ result: ChatMessageList?, _ error: Error?) -> Void)?
    var didGetOrderHistory: ((_ result: OrderHistory?, _ error: Error?) -> Void)?
    
    var addressList: AddressList?
    var chatUsers: ChatUsersList?
    var chatMessages: ChatMessageList?
    var orderHistory: OrderHistory?
    
    var chatId = ""
    var pageIndex = 0
    var pageSize = 0
    var id = ""
    
    func requestDidFinish(with response: Any, method: String, HTTPMethod: HTTPMethod) {
        guard let response = response as? DataResponseWrapper  else {return}
        switch method {
        case ApiEndpoints.getUserProfile:
            switch HTTPMethod {
            case .put:
                didUpdateUserProfile?(response)
            case .get:
                do {
                    profileInfo = try JSONDecoder().decode(ProfileInfoModel.self, from: response.data!)
                    didGetUserProfile?(profileInfo, nil)
                } catch  {
                    didGetUserProfile?(nil, error)
                }
            default:
                break
            }
        case ApiEndpoints.addCard:
            switch HTTPMethod {
            case .post:
                if response.resultError == nil {
                    didAddCard?(response, nil)
                } else {
                    didAddCard?(nil, response.resultError)
                }
            case .get:
                do {
                    cardList = try JSONDecoder().decode(CardList.self, from: response.data!)
                    didGetCardList?(cardList, nil)
                } catch  {
                    didGetCardList?(nil, error)
                }
            default:
                break
            }
            
        case ApiEndpoints.getAdressList:
            switch HTTPMethod {
            case .get:
                do {
                    addressList = try JSONDecoder().decode(AddressList.self, from: response.data!)
                    didGetAddressList?(addressList, nil)
                } catch {
                    didGetAddressList?(nil, error)
                }
            case .put:
                didUpdateAddressByID?(response)
             default:
                break
            }
        case ApiEndpoints.deleteAdressList.replacingOccurrences(of: "#", with: id):
            didDeleteAddressByID?(response)
        case ApiEndpoints.getChatMessages.replacingOccurrences(of: "!", with: chatId).replacingOccurrences(of: "@", with: "\(pageIndex)").replacingOccurrences(of: "#", with: "\(pageSize)"):
            do {
                chatMessages = try JSONDecoder().decode(ChatMessageList.self, from: response.data!)
                didGetChatMessages?(chatMessages, nil)
            } catch {
                didGetChatMessages?(nil, error)
            }
        case ApiEndpoints.getChatUsers:
            do {
                chatUsers = try JSONDecoder().decode(ChatUsersList.self, from: response.data!)
                didGetChatUsers?(chatUsers, nil)
            } catch {
                didGetChatUsers?(nil, error)
            }
        case ApiEndpoints.getOrderHistory.replacingOccurrences(of: "@", with: "\(pageInd)").replacingOccurrences(of: "#", with: "\(pageSiz)"):
            do {
                orderHistory = try JSONDecoder().decode(OrderHistory.self, from: response.data!)
                didGetOrderHistory?(orderHistory, nil)
            } catch {
                didGetOrderHistory?(nil, error)
            }
        default:
            print("kk")
        }
    }
    
    
    func getUserProfile() {
        APIManager.shared.request(with: ProfileEndPoints.getUserProfile, delegate: self)
    }
    
    func updateUserProfile(login: String, firstName: String, lastName: String, middleName: String, sex: Int, password: String, birthday: String, avatarPhotoPath: String, id: String) {
        APIManager.shared.request(with: ProfileEndPoints.updateUserProfile(login: login, firstName: firstName, lastName: lastName, middleName: middleName, sex: sex, password: password, birthday: birthday, avatarPhotoPath: avatarPhotoPath, id: id), delegate: self)
    }
    
    func getCardList() {
        APIManager.shared.request(with: ProfileEndPoints.getCardList, delegate: self)
    }
    
    func addCard(name: String, cardNumber: String, dateOfIssue: String) {
        APIManager.shared.request(with: ProfileEndPoints.addCard(name: name, cardNumber: cardNumber, dateOfIssue: dateOfIssue), delegate: self)
    }
    
    func getAddressList() {
        APIManager.shared.request(with: MainScreenEndpoint.getAddressList, delegate: self)
    }
    
    func updateAddressById(id: String, address: String, lat: Double, lon: Double) {
        APIManager.shared.request(with: MainScreenEndpoint.updateAddressById(id: id, address: address, lat: lat, lon: lon), delegate: self)
    }
    
    func deleteAddressById(id: String) {
        self.id = id
        APIManager.shared.request(with: MainScreenEndpoint.deleteAddressById(id: id), delegate: self)
    }
    
    // Chat
    func getChatUsers() {
        APIManager.shared.request(with: ProfileEndPoints.getChatUsers, delegate: self)
    }
    
    func getChatMessages(id: String, pageIndex: Int, pageSize: Int) {
        self.chatId = id
        self.pageIndex = pageIndex
        self.pageSize = pageSize
        APIManager.shared.request(with: ProfileEndPoints.getChatMessages(id: chatId, pageIndex: pageIndex, pageSize: pageSize), delegate: self)
    }
    
    var pageInd: Int = 0
    var pageSiz: Int = 10
    
    // Order history
    func getOrderHistory(pageIndex: Int, pageSize: Int) {
        pageInd = pageIndex
        pageSiz = pageSize
        APIManager.shared.request(with: ProfileEndPoints.getOrderHistory(pageIndex: pageIndex, pageSize: pageSize), delegate: self)
    }
    
}


