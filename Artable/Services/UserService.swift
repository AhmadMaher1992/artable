//
//  UserService.swift
//  Artable
//
//  Created by mac on 10/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService{
    
  //Variables
    var user: User?
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener: ListenerRegistration? = nil
    var favsListener: ListenerRegistration? = nil
    var isGuest: Bool {
        //if there isn't any logged in Auth user then obviously we are aguest
        guard let authUser = auth.currentUser else { return true}
        //if auth user is anonymous then we also aguest
        if authUser.isAnonymous {
            return true
        }else{
            return false
        }
    }
    
    
    func getCurrentUser(){
        
        //if we don't logged in then there is no user to get
        guard let authUser = auth.currentUser else { return }
        let userRef = db.collection("Users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error =  error {
                debugPrint(error.localizedDescription)
                return
            }
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
            
        })
        
        let favsRef = userRef.collection("favorites").addSnapshotListener { (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        }
        
    }
    
    func logOutUser(){
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = nil
        favorites.removeAll()
    }
    //add selected product to favorite array then to fire store users sub collection (favorites)
    func favoriteSelected(product: Product){
        let favsRef = Firestore.firestore().collection("Users").document(user!.id).collection("favorites")
        if favorites.contains(product){
            //remove from local array of favorites products then from fire
            //remove any product that equal selected one
            favorites.removeAll{ $0  == product }
                favsRef.document(product.id).delete()
         
            
        }else{
            //add as favorite
            favorites.append(product)
            let data = product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    
}
