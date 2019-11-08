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
    var imageUrl: String
    var timeStamp: Timestamp
    var stock: Int
    
    
    init(data: [String: Any]) {
        
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"]  as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    init(name: String , id: String , category: String , price: Double , productDescription: String , imgUrl: String , timeStamp: Timestamp = Timestamp() , stock: Int = 0) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imgUrl
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    func modelToData(product: Product) -> [String : Any]{
        let data: [String: Any] = [
            "name" : product.name ,
            "id" : product.id ,
            "category" : product.category ,
            "price" : product.price ,
            "productDescription" : product.productDescription ,
            "imageUrl" : product.imageUrl ,
            "timeStamp" : product.timeStamp ,
            "stock" : product.stock
        ]
        return data
        
    }
    
}

extension Product: Equatable {
    static func == ( lhs: Product , rhs: Product ) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
