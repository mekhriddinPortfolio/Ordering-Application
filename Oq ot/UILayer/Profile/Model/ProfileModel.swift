//
//  ProfileModel.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 22/08/22.
//

import UIKit

struct ProfileInfoModel: Codable {
    var id: String
    var login: String
    var firstName: String
    var lastName: String
    var middleName: String?
    var sex: Int
    var createdAt: String
    var birthday: String
    var avatarPhotoPath: String
}

struct CardList: Codable {
    let cardInfoToClients: [EachCard]
}

struct EachCard: Codable {
    let id: String
    let clientId: String
    let name: String
    let cardNumber: String
    let dateOfIssue: String
    let cvc: String?
    let cvc2: String?
    let cardHolder: String?
}

// Order History Models

struct OrderHistoryList: Codable {
    let pageIndex: Int
    let totalCount: Int
    let pageCount: Int
    let data: [EachOrder]
}

struct EachOrder: Codable {
    let id: String
    let courierId: String
    let clientId: String
    let createdAt: Int
    let finishedAt: String
    let toLongitude: Int
    let toLatitude: Int
    let isPickup: Bool
    let purchasePrice: Int
    let sellingPrice: Int
    let goodToOrders: [GoodToOrders]
}

struct GoodToOrders: Codable {
    let id: String
    let goodId: String
    let goodName: String
    let goodImagePath: String
    let goodSellingPrice: Int
    let goodDiscount: Int
    let orderId: String
    let count: Int
}
