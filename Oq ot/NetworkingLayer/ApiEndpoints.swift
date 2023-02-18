//
//  ApiEndpoints.swift
//  kkk
//
//  Created by Sirojiddinov Mirjalol on 27/03/22.
//

import Foundation
let baseUrl = "http://128.199.25.228"

struct ApiEndpoints {
    // Registration Endpoints
    static let register = "\(baseUrl):5056/api/auth/register"
    static let yandexRequest = "https://geocode-maps.yandex.ru/1.x/?apikey=033ff716-ddae-4ee8-ae1e-d98fab53b3dc&format=json"
    static let sendValidationCode = "\(baseUrl):5056/api/verify/send"
    static let getCategory = "\(baseUrl):5055/api/1/category?showDeleted=false"
    static let uploadFile = "\(baseUrl):5055/api/1.0/file/upload"
    
    // Main Screen Endpoints
    static let getDiscountedGoods = "\(baseUrl):5055/api/1.0/good/discounted/paged?pageIndex=#&pageSize=10&showDeleted=false&sortable=Name&ascending=true"
    static let getAdressList = "\(baseUrl):5055/api/1.0/addresstoclient"
    static let deleteAdressList = "\(baseUrl):5055/api/1.0/addresstoclient/#"
    static let verifyPhoneNumber = "\(baseUrl):5056/api/verify"
    
    // Profile Endpoints
    static let getUserProfile = "\(baseUrl):5055/api/1.0/profile"
//    static let updateUserProfile = "\(baseUrl):5055/api/1.0/profile"
    static let addCard = "\(baseUrl):5055/api/1.0/cardinfotoclient"
    static let getGoodsByID = "\(baseUrl):5055/api/1.0/good/random/category/#"
    static let getMainScreenGoods = "\(baseUrl):5055/api/1.0/good/random/main"
    static let getPagedgoodsBySubCatId = "\(baseUrl):5055/api/1.0/good/paged/category/#?pageSize=10&pageIndex=@&showDeleted=false&sortable=Name&ascending=true"
    static let getOrderHistory = "\(baseUrl):5055/api/1.0/order/client/last/paged?pageIndex=@&pageSize=#"
    
    // Chat Endpoints
    static let getChatUsers = "\(baseUrl):5055/api/1.0/chat/users"
    static let getChatMessages = "\(baseUrl):5055/api/1.0/chat/!?pageIndex=@&pageSize=#"
    
    
    // Formalization Endpoints
    static let sendFormalizationDetails = "\(baseUrl):5055/api/1.0/order"
    static let getListOfStores = "\(baseUrl):5055/api/1.0/store?showDeleted=false"
    static let getListOfPaymentTypes = "\(baseUrl):5055/api/1.0/paymenttype"
    static let searchGoods = "\(baseUrl):5055/api/1.0/good/search?searchQuery=#&pageSize=20&pageIndex=%"
    
}


