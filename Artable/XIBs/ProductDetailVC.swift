//
//  ProductDetailVCViewController.swift
//  Artable
//
//  Created by mac on 10/15/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    
    //Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTilte: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    //Variables
    var product: Product!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        productTilte.text = product.name
        productDescription.text = product.productDescription
        if let url = URL(string: product.imgUrl ){
            productImg.kf.setImage(with: url)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber){
            productPrice.text = price
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)

       
    }
    @objc func dismissProduct(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addProductClicked(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
