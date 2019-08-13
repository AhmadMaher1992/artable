//
//  LoginVC.swift
//  Artable
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty ,
            let password = passTxt.text , password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please Fillout All fields")
                return
                
        }
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error , vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            self.simpleAlert(title: "Hello", msg: "Succcessful Login")
        }
    }
    
    @IBAction func forgetPassClicked(_ sender: Any) {
        let modalVC = ForgotPasswordVC()
        modalVC.modalTransitionStyle = .crossDissolve
        modalVC.modalPresentationStyle = .overCurrentContext
        present(modalVC, animated: true, completion: nil)
        
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }
    
}
