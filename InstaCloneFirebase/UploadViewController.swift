//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Bedirhan Altun on 3.08.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func showError(message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        
        //Storage'a ulaşmak
        let storage = Storage.storage()
        //Referansı değişkene eşitlemek
        let storageReference = storage.reference()
        //Açtığımız klasöre ulaşmak veya klasör açmak
        let mediaFolder = storageReference.child("media")
        //Resmi dataya çevirmek ve sıkıştırmak.
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let UUID = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(UUID).jpg")
            //
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.showError(message: error?.localizedDescription ?? "Error")
                }
                else {
                    //kullanıcının indirdiği fotoğrafı hangi url ye kaydettiğini hangi siteden aldığını çekiyoruz.
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            //url yi alıp stringe ceviriyoruz.
                            let imageUrl = url?.absoluteString
                            
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            let firestoreReference : DocumentReference?
                            //String to Any sözlüğü oluşturmak.Database'in içinde neler olacağını key-value şeklinde gösteriyoruz.
                            let firestorePost = ["imageUrl" : imageUrl,
                                                 "postedBy" : Auth.auth().currentUser!.email!,
                                                 "commentText" : self.commentTextField.text!,
                                                 "date" : FieldValue.serverTimestamp(),
                                                 "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.showError(message: error?.localizedDescription ?? "Error!!")
                                }
                                else {
                                    self.imageView.image = UIImage(named: "selectimage")
                                    self.commentTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //Kullanıcı resmi seçtiğinde ne olacak ?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //info sözlük içerisinden originalImage'ı alıyoruz.
        imageView.image = info[.originalImage] as? UIImage
        // picker controller işini bitirmek.
        self.dismiss(animated: true, completion: nil)
    }
}
