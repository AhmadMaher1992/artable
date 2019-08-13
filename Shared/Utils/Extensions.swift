//
//  Extensions.swift
//  Artable
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension String {
    var isNotEmpty: Bool{
        return !isEmpty
    }
}

extension UIViewController {
    
    func presentViewController( storyboard: String , viewController: String){
        let storyboard = UIStoryboard.init(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewController)
        present(controller, animated: true, completion: nil)
    }
    
    
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}




