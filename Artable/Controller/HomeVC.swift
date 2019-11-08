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
    //MARK: - outlet
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - variables
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    //MARK: - ViewDidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setUpCollectionView()
        setUpAnonymousUser()
//        setUpNavigationBar()
    }
    
    func setUpCollectionView(){
        collectionView.dataSource = self
              collectionView.delegate = self
              collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    func setUpAnonymousUser(){
        if Auth.auth().currentUser == nil {
                  Auth.auth().signInAnonymously { (result, error) in
                      if let error = error {
                          Auth.auth().handleFireAuthError(error: error , vc: self)
                          debugPrint(error.localizedDescription)
                      }
                  }
              }
    }
    
//    func setUpNavigationBar(){
//        guard let font = UIFont(name: "futura", size: 26 ) else { return }
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white , NSAttributedString.Key.font: font]
//
//    }
//
    
    
    
    
    func presentLoginController(){
        let storyboard = UIStoryboard.init(name: Storyboards.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllerID.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let user = Auth.auth().currentUser , !user.isAnonymous {
            loginOutBtn.title = "LogOut"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        }else{
            loginOutBtn.title = "Login"
        }
        addCategoryListener()
        
    }
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        //In anonymous state we don't want to signout of firebase session
        if  user.isAnonymous {
            presentLoginController()
            
        }else {
            
            do{
                try Auth.auth().signOut()
                UserService.logOutUser()
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
    
    //MARK: - FireStore Fetch Data
    func addCategoryListener(){
        listener = db.collection("Categories").order(by: "timeStamp", descending: true).addSnapshotListener({ (snap, error) in
            if let error = error { debugPrint(error.localizedDescription)
                return   }
            snap?.documentChanges.forEach({ (changeDocument) in
                let data = changeDocument.document.data()
                let newCategory = Category.init(data: data)
                switch changeDocument.type {
                case .added:
                    self.onDocumentAdded(changeDoc: changeDocument , category: newCategory)
                case .modified:
                    self.onDocumentModified(changeDoc: changeDocument , category: newCategory)
                case .removed:
                    self.onDocumentRemoved(changeDoc: changeDocument)
                default:
                    print("")
                }
            })
              
        })
        
    }
    
    func onDocumentAdded(changeDoc: DocumentChange , category: Category){
        let newIndex = Int(changeDoc.newIndex)
        categories.insert(category, at: newIndex)
        let indexPath = IndexPath(item: newIndex, section: 0)
        collectionView.insertItems(at: [indexPath])
    
    
    }
    func onDocumentModified(changeDoc: DocumentChange , category: Category){
        if changeDoc.newIndex == changeDoc.oldIndex {
            let index = Int(changeDoc.newIndex)
            categories[index] = category
            let indexColl = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexColl])
            
        }else{
            let oldIndex = Int(changeDoc.oldIndex)
            let newIndex = Int(changeDoc.oldIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            let oldColl = IndexPath(item: oldIndex, section: 0)
            let newColl = IndexPath(item: newIndex, section: 0 )
            collectionView.moveItem(at: oldColl , to: newColl)
        }
        
    }
    func onDocumentRemoved(changeDoc: DocumentChange){
        let oldIndex = Int(changeDoc.oldIndex)
        categories.remove(at: oldIndex)
        let index = IndexPath(item: oldIndex, section: 0)
        collectionView.deleteItems(at: [index] )
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
}




//MARK: - HomeVC Extension

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
        }else if segue.identifier == Segues.ToFavorites {
            if let destination = segue.destination as?  ProductsVC{
                 destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
    
}


//func fetchCollection(){
//       let collectionRef = db.collection("Categories")
//       listener = collectionRef.addSnapshotListener { (snap, error) in
//           guard let documents = snap?.documents else { return}
//           print(snap?.documentChanges.count)
//           self.categories.removeAll()
//           for document in documents {
//               let data = document.data()
//               let newCategory = Category.init(data: data)
//               self.categories.append(newCategory)
//               self.collectionView.reloadData()
//           }
//     }
//func fetchDocument(){
//
//    let docRef = db.collection("Categories").document("FqX7G4qAI7p7eHaHAmTj")
//     listener = docRef.addSnapshotListener { (snap, error) in
//        guard let data = snap?.data() else {return}
//        self.categories.removeAll()
//        let newCategory = Category.init(data: data)
//        self.categories.append(newCategory)
//        self.collectionView.reloadData()
//    }
//
//}
