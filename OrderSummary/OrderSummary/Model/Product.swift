//
//  Product.swift
//  OrderSummary
//
//  Created by Alexandre Gravelle on 2018-09-12.
//  Copyright © 2018 Alexandre Gravelle. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Product {
    let id: Int,
    title: String,
    subTitle: String,
    tags: [String],
    variants: [JSON],
    inventory: Int,
    imageURL: String

}
