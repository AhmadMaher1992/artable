//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by mac on 10/15/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    
    //Variables
    var categoryToEdit: Category?
 
    
    
    //Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.addGestureRecognizer(tap)
        
        //Category Editing
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("SaveChanges", for: .normal)
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
        
    }
    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        launchImagePicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument(){
        
        guard let image = categoryImg.image , let categoryName = nameTxt.text , categoryName.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Must Add Category Image and Name")
            return
            
        }
        
        activityIndicator.startAnimating()
        //Step1: Turn the image into data
        guard let imgData = image.jpegData(compressionQuality: 0.2) else{ return }
        //Step2: Create Astorage Image Reference
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        //Step3: Set the Meta Data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //Step4: upload the data
        imageRef.putData(imgData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable To Upload Image.")
                return
            }
            //Step5: Once the image Uploaded , retrieve Download URL
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable To Retrieve Image Url")
                    return
                }
                guard let url = url else { return }
                //Step6: Upload new Category Document to the FireStore Categories Collection
                self.uploadDocument(url: url.absoluteString)
            }
        }
        
    }
    
    func uploadDocument(url: String){
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            //Editing Case
            docRef = Firestore.firestore().collection("Categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        }else{
            //Add New Category
            docRef = Firestore.firestore().collection("Categories").document()
            category.id = docRef.documentID
            
        }
        let data = category.modeltoData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable To Upload  New Category To FireStore")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error , msg: String){
        debugPrint(error.localizedDescription)
        activityIndicator.stopAnimating()
        simpleAlert(title: "Error", msg: msg)
    }
    
}



extension AddEditCategoryVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func launchImagePicker(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


