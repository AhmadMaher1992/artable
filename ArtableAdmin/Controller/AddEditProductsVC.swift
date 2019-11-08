//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by mac on 10/19/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    //Variables
    var productToEdit: Product?
    var selectedCategory: Category!
    
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    
    //Outlets
    
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productpriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    @IBOutlet weak var descLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector( imageTapped))
        tap.numberOfTouchesRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.clipsToBounds = true
        productImgView.addGestureRecognizer(tap)
        //Editing case
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescTxt.text = product.productDescription
            productpriceTxt.text = String(product.price)
            addBtn.setTitle("SaveChanges", for: .normal)
            descLbl.text = "Product Description."
            if let url = URL(string: product.imageUrl as String){
                productImgView.contentMode = .scaleAspectFill
                productImgView.kf.setImage(with: url)
            }
            
        }
        
    }
    @objc func imageTapped(){
        //Launch Image Picker
        launchImagePicker()
    }
    
    
    
    @IBAction func addClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument(){
        
        guard let image = productImgView.image ,
            let name = productNameTxt.text , name.isNotEmpty ,
            let description = productDescTxt.text , description.isNotEmpty,
            let priceStr = productpriceTxt.text , priceStr.isNotEmpty ,
            let price = Double(priceStr)
            
            else {
                simpleAlert(title: "Missing Field!", msg: "Please Fill Out All Fields.")
                return
                
        }
        self.name = name
        self.productDescription = description
        self.price = price
        
        activityIndicator.startAnimating()
        //Step1: Turn the image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        //Step2: Create Astorage Image Reference
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        //Step3: Set the Meta Data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //Step4: upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
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
                
                //Step6: Upload new Document Document to the FireStore Products Collection
                self.uploadDocument(url: url.absoluteString)
            }
        }
        
        
        
        
    }
    
    func uploadDocument(url: String){
        
        var docRef: DocumentReference!
        var product = Product.init(name: name, id: "", category: selectedCategory.id, price: price, productDescription: productDescription , imgUrl: url)
        
        if let productToEdit = productToEdit {
            //Editing Mode -> Set the docRef To Point to the Existing Product
            docRef = Firestore.firestore().collection("Products").document(productToEdit.id)
            product.id = productToEdit.id
        }else{
            docRef = Firestore.firestore().collection("Products").document()
            product.id = docRef.documentID
        }
        let data = product.modelToData(product: product)
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

extension AddEditProductsVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func launchImagePicker(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
