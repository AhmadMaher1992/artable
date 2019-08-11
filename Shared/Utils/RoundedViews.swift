//
//  RoundedViews.swift
//  Artable
//
//  Created by mac on 8/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
class RoundedShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}
class RoundedImageView: UIImageView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
