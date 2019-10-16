//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        let addCategoryBtn = UIBarButtonItem(title: "AddCategory", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryBtn
    }
    
    @objc func addCategory(){
        performSegue(withIdentifier: Segues.toAddEditCategory, sender: self)
        
    }
    
    
}

