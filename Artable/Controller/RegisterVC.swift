//
//  RegisterVC.swift
//  Artable
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    // MARK: - outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmpassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTxt.text , !email.isEmpty ,
              let username = usernameTxt.text , !username.isEmpty ,
              let password = passwordTxt.text , !password.isEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                debugPrint(error)
                return
            }
            print("Successful Register")
        }

    }
    
}
