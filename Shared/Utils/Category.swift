//
//  Category.swift
//  Artable
//
//  Created by mac on 8/13/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseFirestore

// module that will represent our categories and will be able to initialize instances of this category from data that we pulled down from fireStore database

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
