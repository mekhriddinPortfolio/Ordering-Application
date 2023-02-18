//
//  Model.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 22/07/22.
//

import UIKit

struct CategoryModel: Codable {
    var categories: [EachCategory]
}
struct EachCategory: Codable {
    var id: String
    var name: String
    var imageUrl: String?
    var isMainCategory: Bool
    var children: [String?]?
    
    init() {
        self.id = ""
        self.name = "Все"
        self.imageUrl = ""
        self.isMainCategory = false
        self.children = []
    }
}


struct DiscountedGoodsModel: Codable {
    var data: [EachDiscountedGood]
    let pageIndex: Int
    let pageCount: Int
    let totalCount: Int
}
struct EachDiscountedGood: Codable {
    let id : String
    let name: String
    let description: String
    let photoPath: String?
    let purchasePrice: Int
    let sellingPrice: Int
    let discount: CGFloat
    let count: Int?
}


struct EachDiscountedGoodForCoreData: Codable {
    let id : String
    let name: String
    let description: String
    let photoPath: String
    let purchasePrice: Int
    let sellingPrice: Int
    let discount: Double
    let liked: Bool
    let count: Int
}

struct CategoryWithGoods: Codable {
    var categories: [EachCategoryWithGoods]
}

struct EachCategoryWithGoods: Codable {
    var category: EachCategory
    var goods: [EachDiscountedGood]
    init() {
        self.category = EachCategory()
        self.goods = []
    }
}

struct AddressList: Codable {
    let addressToClients: [EachAddress]
}

struct EachAddress: Codable {
    var address : String
    var longitude: Double
    var clientId: String
    var createdAt: String
    var latitude: Double
    var id: String
    init() {
        self.address = ""
        self.longitude = 0.0
        self.clientId = ""
        self.createdAt = ""
        self.latitude = 0.0
        self.id = ""
    }
    
    init(address: String, longitude: Double, clientId: String, createdAt: String, latitude: Double, id: String ) {
        self.address = address
        self.longitude = longitude
        self.clientId = clientId
        self.createdAt = createdAt
        self.latitude = latitude
        self.id = id
    }
    
}

struct EachAddressForCoreData: Codable {
    let address : String
    let longitude: Double
    let clientId: String
    let createdAt: String
    let latitude: Double
    let id: String
    let isSelected: Bool
}
