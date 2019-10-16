//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by mac on 10/15/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.addGestureRecognizer(tap)
        
        
        
    }
    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        launchImagePicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
