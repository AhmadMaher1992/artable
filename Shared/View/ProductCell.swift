//
//  ProductCell.swift
//  Artable
//
//  Created by mac on 8/14/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTilte: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    //create delegate variable
    weak var delegate: ProductCellDelegate?
    private var product: Product!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         productImg.layer.cornerRadius = 5
    }
    func configureCell(product: Product , delegate: ProductCellDelegate)  {
        self.product = product
        self.delegate = delegate
        productTilte.text = product.name
        if let url = URL(string: product.imageUrl){
            let placeholder = UIImage(named: AppImages.placeholder)
          let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.indicatorType = .activity
            productImg.kf.setImage(with: url , placeholder: placeholder , options: options )
           
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        //Favorite Product
        if UserService.favorites.contains(product){
            favoriteBtn.setImage(UIImage(named: AppImages.filledStar), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: AppImages.emptyStar), for: .normal)
        }
        
        
    }
    
    
    @IBAction func addToCartClicked(_ sender: Any) {
        
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
        
    }
    
}
