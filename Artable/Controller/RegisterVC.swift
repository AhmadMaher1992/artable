//
//  RegisterVC.swift
//  Artable
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterVC: UIViewController {
    // MARK: - outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmpassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmCheckImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmpassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        guard let password = passwordTxt.text else { return }
        
        
        if textField == confirmpassTxt {
            passCheckImg.isHidden = false
            confirmCheckImage.isHidden = false
        }else {
            let password = passwordTxt.text
            if password!.isEmpty {
                confirmpassTxt.text = ""
                confirmCheckImage.isHidden = true
                passCheckImg.isHidden = true
                
            }
        }
        // when password matchs the checkmark turns green
        if passwordTxt.text == confirmpassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.greenCheck)
            confirmCheckImage.image = UIImage(named: AppImages.greenCheck)
        }else {
            passCheckImg.image = UIImage(named: AppImages.redCheck)
            confirmCheckImage.image = UIImage(named: AppImages.redCheck)
        }
        
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty,
            let username = usernameTxt.text , username.isNotEmpty ,
            let password = passwordTxt.text , password.isNotEmpty else { return }
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                debugPrint(error)
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            print("Successful Register")
        }
        
    }
    
}
