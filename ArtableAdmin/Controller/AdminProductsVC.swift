//
//  AdminProductsVC.swift
//  ArtableAdmin
//
//  Created by mac on 10/19/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    var selectedproduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        navigationItem.setRightBarButtonItems([editCategoryBtn , newProductBtn], animated: false)

       
    }
    

    @objc func editCategory(){
        performSegue(withIdentifier: Segues.toEditCategory, sender: self)
    }
    @objc func newProduct(){
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    

}


extension AdminProductsVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedproduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC{
                destination.selectedCategory = category
                destination.productToEdit = selectedproduct
            }
        }else if segue.identifier == Segues.toEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
    
}
