//
//  MainScreenViewModel.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 22/07/22.
//

import Foundation
import Alamofire

class MainScreenViewModel: APIManagerDelegate {
    var catID = ""
    var canBeRequsted = true
    var didGetCategoryList: ((_ result: CategoryModel?, _ error: Error?) -> Void)?
    var categoryList: CategoryModel?
    var didGetDiscountedGoods: ((_ result: DiscountedGoodsModel?, _ error: Error?) -> Void)?
    var discountedGoods: DiscountedGoodsModel?
    
    var didGetAddressList: ((_ result: AddressList?, _ error: Error?) -> Void)?
    var didUpdateAddressByID: (( _ responce: DataResponseWrapper?) -> Void)?
    var didDeleteAddressByID: (( _ responce: DataResponseWrapper?) -> Void)?
    var addressList: AddressList?
    
    var didGetGoodsWithCat: ((_ result: CategoryWithGoods?, _ error: Error?) -> Void)?
    var goodsWithCategory: CategoryWithGoods?

    var didGetGoodsWithCatForMain: ((_ result: CategoryWithGoods?, _ error: Error?) -> Void)?
    var goodsWithCategoryForMain: CategoryWithGoods?
    var didGetSearchedGoods: ((_ result: DiscountedGoodsModel?, _ error: Error?) -> Void)?
    var searchedGoods: DiscountedGoodsModel?
    
    
    var subCatId = ""
    var page = 0
    var discountPage = 0

    var query = ""
    
    func requestDidFinish(with response: Any, method: String, HTTPMethod: HTTPMethod) {
        guard let response = response as? DataResponseWrapper  else {return}
        switch method {
        case ApiEndpoints.getCategory:
            do {
                categoryList = try JSONDecoder().decode(CategoryModel.self, from: response.data!)
                didGetCategoryList?(categoryList, nil)
            } catch {
               didGetCategoryList?(nil, error)
            }
            
        case ApiEndpoints.getDiscountedGoods.replacingOccurrences(of: "#", with: String(discountPage)):
            do {
                discountedGoods = try JSONDecoder().decode(DiscountedGoodsModel.self, from: response.data!)
                didGetDiscountedGoods?(discountedGoods, nil)
            } catch {
                didGetDiscountedGoods?(nil, error)
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
            case .delete:
                didDeleteAddressByID?(response)
             default:
                break
            }
        case ApiEndpoints.getGoodsByID.replacingOccurrences(of: "#", with: catID):
            canBeRequsted = true
            do {
                goodsWithCategory = try JSONDecoder().decode(CategoryWithGoods.self, from: response.data!)
                didGetGoodsWithCat?(goodsWithCategory, nil)
            } catch {
                didGetGoodsWithCat?(nil, error)
            }
            
        case ApiEndpoints.getMainScreenGoods:
            do {
                goodsWithCategoryForMain = try JSONDecoder().decode(CategoryWithGoods.self, from: response.data!)
                didGetGoodsWithCatForMain?(goodsWithCategoryForMain, nil)
            } catch {
                didGetGoodsWithCatForMain?(nil, error)
            }
            
        case ApiEndpoints.getPagedgoodsBySubCatId.replacingOccurrences(of: "#", with: subCatId).replacingOccurrences(of: "@", with: String(page)):
         return
            
        case ApiEndpoints.searchGoods.replacingOccurrences(of: "#", with: query).replacingOccurrences(of: "%", with: String(page)):
            do {
                searchedGoods = try JSONDecoder().decode(DiscountedGoodsModel.self, from: response.data!)
                didGetSearchedGoods?(searchedGoods, nil)
            } catch {
                didGetSearchedGoods?(nil, error)
            }
            
        default:
            break
        }
    }
  
    
    func getCategory() {
        APIManager.shared.request(with: MainScreenEndpoint.getCategories, delegate: self)
    }
    
    func getGoodsByCategoryID(catID: String) {
        self.catID = catID
        if canBeRequsted {
            canBeRequsted = false
            APIManager.shared.request(with: MainScreenEndpoint.getGoodsByCatID(catID: catID), delegate: self)
        }
        
    }
    func getDiscountedGoods(page: Int) {
        self.discountPage = page
        APIManager.shared.request(with: MainScreenEndpoint.getDiscountedGoods(page: page), delegate: self)
    }
    
    func searchGoods(queryString: String, page: Int) {
        self.query = queryString
        self.page = page
        APIManager.shared.request(with: MainScreenEndpoint.searchGoods(queryString: queryString, page: String(page)), delegate: self)
    }
    
    func getAddressList() {
        APIManager.shared.request(with: MainScreenEndpoint.getAddressList, delegate: self)
    }
    
    func updateAddressById(id: String, address: String, lat: Double, lon: Double) {
        APIManager.shared.request(with: MainScreenEndpoint.updateAddressById(id: id, address: address, lat: lat, lon: lon), delegate: self)
    }
    
    func deleteAddressById(id: String) {
        APIManager.shared.request(with: MainScreenEndpoint.deleteAddressById(id: id), delegate: self)
    }
    
    func getMainScreenGoodCategories() {
        APIManager.shared.request(with: MainScreenEndpoint.getMainScreenGoodCategories, delegate: self)
    }
    
    func getPagedListOfGoodsBySubCatID() {
        APIManager.shared.request(with: MainScreenEndpoint.getPagedgoodsBySubCatId(id: subCatId, pageNumber: String(page)), delegate: self)
    }
    
    
    
}
