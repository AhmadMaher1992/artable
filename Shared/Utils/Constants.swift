
//
//  Constants.swift
//  Artable
//
//  Created by mac on 8/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

struct Storyboards {
    static let Main = "Main"
    static let LoginStoryboard = "LoginStoryboard"
}

struct ViewControllerID {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let greenCheck = "green_check"
    static let redCheck = "red_check"
    static let filledStar = "filled_star"
    static let emptyStar = "empty_star"
    static let placeholder = "placeholder"
}

struct AppColors {
    static let blue = #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.3607843137, alpha: 1)
    static let red = #colorLiteral(red: 0.8352941176, green: 0.3921568627, blue: 0.3137254902, alpha: 1)
    static let ofWhite = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
}

struct Segues{
    static let ToProducts = "toProductsVC"
    static let toAddEditCategory = "toAddEditCategory"
    static let toEditCategory = "toEditCategory"
    static let toAddEditProduct = "toAddEditProduct"
    static let ToFavorites = "ToFavorites"
}
