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
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        
    }
    
    func presentLoginController(){
        let storyboard = UIStoryboard.init(name: Storyboards.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerID.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let user = Auth.auth().currentUser , !user.isAnonymous {
            loginOutBtn.title = "LogOut"
        }else{
            loginOutBtn.title = "Login"
        }
        
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
     
        guard let user = Auth.auth().currentUser else { return }
//In anonymous state we don't want to signout of firebase session
        if  user.isAnonymous {
            presentLoginController()
        }else {
            
            do{
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        
                    }
                    self.presentLoginController()
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    
}

