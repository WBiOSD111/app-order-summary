//
//  ProductService.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2019-01-09.
//  Copyright © 2019 Alexandre Gravelle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductService {
    
    static let instance = ProductService()
    
    var collects = [Int]()
    var products = [Product]()
    
    func findAllCollects(collectionId: Int, completion: @escaping CompletionHandler) {
        collects.removeAll()
        Alamofire.request(COLLECTS + "collection_id=\(collectionId)&page=1&access_token=" + AuthService.instance.authToken)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        completion(false)
                        debugPrint(response.result.error as Any)
                        return
                }
                
                _ = JSON(value)["collects"].array!.map { json in
                    let productId = json["product_id"].intValue
                    let collect = productId
                    self.collects.append(collect)
                    
                }
                
                completion(true)
        }
    }
    
    //https://shopicruit.myshopify.com/admin/products.json?ids=2759137027,2759143811&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6
    
    func findAllProducts(productIds: [Int], completion: @escaping CompletionHandler ) {
        products.removeAll()
        var productIdsString = ""
        for productId in productIds {
            productIdsString += "\(productId),"
        }
        
        Alamofire.request(PRODUCTS + "ids=\(productIdsString)&page=1&access_token=" + AuthService.instance.authToken)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        completion(false)
                        debugPrint(response.result.error as Any)
                        return
                }
                
                _ = JSON(value)["products"].array!.map { json in
                    let productId = json["id"].intValue
                    let productTitle = json["title"].stringValue
                    let productSubTitle = json["body_html"].stringValue
                    let productTags = json["tags"].stringValue
                    let productVariants = json["variants"].arrayValue
                    let productImageURL = json["image"]["src"].stringValue
                    
                    // Calculate total inventory by looking through each variant
                    var productInventory: Int = 0
                    
                    for variant in productVariants {
                        
                        productInventory += variant["inventory_quantity"].intValue
                        
                    }
                    
                    // Convert the tags into a String Array
                    let productTagsArray = productTags.components(separatedBy: ", ").filter {!$0.isEmpty}
                    
                    let product = Product.init(id: productId, title: productTitle, subTitle: productSubTitle, tags: productTagsArray, variants: productVariants, inventory: productInventory, imageURL: productImageURL)
                    self.products.append(product)
                    
                }
                
                //self.sort()
                completion(true)
                    
                }
                
        
        
    }
}
