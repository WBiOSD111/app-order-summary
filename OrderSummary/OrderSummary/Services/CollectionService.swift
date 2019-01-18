//
//  CollectionService.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2019-01-09.
//  Copyright © 2019 Alexandre Gravelle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CollectionService {
    
    static let instance = CollectionService()
    
    var collections = [Collection]()
    
    func findAllCollections(completion: @escaping CompletionHandler) {
        Alamofire.request(CUSTOM_COLLECTIONS + "page=1&access_token=" + AuthService.instance.authToken)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard response.result.isSuccess,
                    let value = response.result.value else {
                        completion(false)
                        debugPrint(response.result.error as Any)
                        return
                }
                
                _ = JSON(value)["custom_collections"].array!.map { json in
                    let id = json["id"].intValue
                    let title = json["title"].stringValue
                    
                    let collection = Collection.init(id: id, title: title)
                    self.collections.append(collection)
                    
                }
                
                completion(true)
        }
    }
}
