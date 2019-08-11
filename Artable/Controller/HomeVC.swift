//
//  ViewController.swift
//  Artable
//
//  Created by mac on 8/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeVC: UIViewController {
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func presentLoginController(){
        let storyboard = UIStoryboard.init(name: Storyboards.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerID.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBAction func loginOutClicked(_ sender: Any) {
        if let _ =  Auth.auth().currentUser {
            do{
                try Auth.auth().signOut()
                loginOutBtn.title = "LogOut"
                presentLoginController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }else{
            loginOutBtn.title = "Login"
            presentLoginController()
        }
    }
    
}

