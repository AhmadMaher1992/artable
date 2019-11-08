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
            let password = passwordTxt.text , password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "please , Fill out all fields.")
                return
                
        }
        guard let confirmPass = confirmpassTxt.text , confirmPass == password  else {
            simpleAlert(title: "Error", msg: "Password Don't Match")
            return
        }
        activityIndicator.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error , vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            guard let firUser = result?.user else { return }
            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            //Upload to FireStore
            self.createFireStoreUser(user: artUser)
            
        }
        
        
    }
    func createFireStoreUser(user: User){
        //Step1: Create Document Reference
        let newUserRef = Firestore.firestore().collection("Users").document(user.id)
        //Step2: Create Model Data
        let data = User.modelToData(user: user)
        //Step3: Upload To FireStore
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Error SigIn: \(error.localizedDescription))")
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
        
        
    }
    
    
    
    
    
    /*
     //this method used to link any currently authentication user with approved provider in this case email&password by providing credentials
     
     guard let authUser = Auth.auth().currentUser else { return }
     let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
     authUser.link(with: credentials) { (result, error) in
     if let error = error {
     Auth.auth().handleFireAuthError(error: error , vc: self)
     self.activityIndicator.stopAnimating()
     return
     }
     self.activityIndicator.stopAnimating()
     self.dismiss(animated: true, completion: nil)
     self.simpleAlert(title: "Hello", msg: "SUCCESSFUL REGISTER")
     }
     
     */
}




