//
//  FormalizationModel.swift
//  Oq ot
//
//  Created by AvazbekOS on 22/08/22.
//

import UIKit

struct PaymentTypeModel {
    let text: String
    let image: String
}

class FormalizationModel {
    var comment: String?
    var dontCallWhenDelivered: Bool?
    var destinationType: Int = 0
    var floor: Int = 0
    var entrance: Int = 0
    var toLongitude: Double?
    var toLatitude: Double?
    var toLongitudeForPickup: Double?
    var toLatitudeForPickup: Double?
    var isPickup: Bool = false
    var paymentTypeId: String?
    var promo: String = ""
    var deliverAt: String?
    var goods: [[String: Any]]?
}

struct AddressCoordinate {
    var toLongitude: Double?
    var toLatitude: Double?
}

struct EachGood {
    var id: String
    var count: Int
}

struct ListOfPaymentTypes: Codable {
    let paymentTypes: [EachPaymentType]
}

struct EachPaymentType: Codable {
    let id, name, nameRu, nameEn, nameUz: String?
}

struct ListOfStores: Codable {
    let stores: [EachStore]
}

struct EachStore: Codable {
    let id, name, nameRu, nameEn, nameUz: String?
    let latitude, longitude: Double?
    let address, addressRu, addressEn, addressUz, phoneNumber: String?
}


