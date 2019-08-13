//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by mac on 8/13/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func resetClicked(_ sender: Any) {
        guard let email = emailTxt.text else {
            simpleAlert(title: "Error", msg: "please, Enter your Email.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                return
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
