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
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
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
        fetchCollection()
        
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
    
    func fetchDocument(){
        
        let docRef = db.collection("Categories").document("FqX7G4qAI7p7eHaHAmTj")
         listener = docRef.addSnapshotListener { (snap, error) in
            guard let data = snap?.data() else {return}
            self.categories.removeAll()
            let newCategory = Category.init(data: data)
            self.categories.append(newCategory)
            self.collectionView.reloadData()
        }
       
    }
    
    func fetchCollection(){
        let collectionRef = db.collection("Categories")
        listener = collectionRef.addSnapshotListener { (snap, error) in
            guard let documents = snap?.documents else { return}
            print(snap?.documentChanges.count)
            self.categories.removeAll()
            for document in documents {
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categories.append(newCategory)
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
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
        let cellWidth = ( width - 30 ) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC{
                destination.category = selectedCategory
            }
        }
    }
    
}
