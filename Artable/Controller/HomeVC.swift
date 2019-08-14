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
    //outlet
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //variables
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error , vc: self)
                    debugPrint(error.localizedDescription)
                }
            }
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        let category = Category.init(name: "Shoes", id: "123", imgUrl: "https://images.unsplash.com/photo-1565778287157-522dd69d006e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", isActive: true, timeStamp: Timestamp())
        categories.append(category)
        
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
                        Auth.auth().handleFireAuthError(error: error , vc: self)
                        debugPrint(error.localizedDescription)
                        
                    }
                    self.presentLoginController()
                }
            }catch{
              Auth.auth().handleFireAuthError(error: error , vc: self)
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    
}

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = ( width - 50 ) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
}
