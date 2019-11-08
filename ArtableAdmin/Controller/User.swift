//
//  User.swift
//  Artable
//
//  Created by mac on 10/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct User {
    
    
    var id: String
    var email: String
    var username: String
    var stripeId: String
    
 
    init(id: String = "" ,
         email: String = "" ,
         username: String ,
         stripeId: String = "") {
        
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
        
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
    }
    
    static func modelToData(user: User) -> [String : Any]{
        let data: [String: Any] = [
            "id": user.id ,
            "email": user.email ,
            "username": user.username ,
            "striprId": user.stripeId
            
        ]
        return data
        
    }
    
    
    
}
