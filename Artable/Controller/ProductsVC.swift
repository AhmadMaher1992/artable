//
//  ProductsVC.swift
//  Artable
//
//  Created by mac on 8/14/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    //variables
    var products = [Product]()
    var category: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        db = Firestore.firestore()
        tableview.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        setUpQuery()
        
    }
    
    func setUpQuery(){
        listener = db.collection("Products").whereField("category", isEqualTo: category.id).order(by: "timeStamp" , descending: true).addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let newProduct = Product.init(data: data)
                
                switch change.type {
                    
                case .added:
                    self.onDocumentAdded(product: newProduct , change: change)
                case .modified:
                    self.onDocumentModified(product: newProduct , change: change)
                case .removed:
                    self.onDocumentRemoved(change: change)
               
                default:
                    print("No")
                }
                
            })
            
            
        })
    }
    
    func onDocumentAdded(product: Product , change: DocumentChange){
        let newindex = Int(change.newIndex)
        products.insert(product, at: newindex)
        tableview.insertRows(at: [IndexPath(row: newindex, section: 0 )], with: .fade)
        
    }
    func onDocumentModified(product: Product , change: DocumentChange){
        let newIndex = Int(change.newIndex)
        let oldIndex = Int(change.oldIndex)
        if newIndex == oldIndex {
            products[newIndex] = product
            tableview.reloadRows(at: [IndexPath(row: newIndex, section: 0)], with: .none)
            
        }else{
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            let newIndex = IndexPath(row: newIndex, section: 0)
            let oldIndex = IndexPath(row: oldIndex, section: 0)
            tableview.moveRow(at: oldIndex, to: newIndex)
            
            
        }
    }
    func onDocumentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        let index = IndexPath(row: oldIndex, section: 0)
        tableview.deleteRows(at: [index], with: .left)
        
    }

    
}







extension ProductsVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
