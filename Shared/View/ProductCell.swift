//
//  ProductCell.swift
//  Artable
//
//  Created by mac on 8/14/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTilte: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(product: Product)  {
        productTilte.text = product.name
        if let url = URL(string: product.imgUrl){
            productImg.kf.setImage(with: url)
        }
    }
    
    
    @IBAction func addToCartClicked(_ sender: Any) {
        
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        
    }
    
}
