//
//  Product.swift
//  Artable
//
//  Created by mac on 8/14/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
     var imgUrl: String
    var timeStamp: Timestamp
    var stock: Int
    var favorite: Bool
}
