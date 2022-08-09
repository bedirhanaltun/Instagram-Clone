//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Bedirhan Altun on 3.08.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        /*
         //Firebase database'in ayarlarını değiştirmek için kullanılan bir yöntem.
         let settings = firestoreDatabase.settings
         //Firestore database'in settingsini kendi settingsime eşitliyorum.
         firestoreDatabase.settings = settings
         */
        
        //Hangi collectionda işlem yapacağımı belirtiyorum.Snapshot listener --> Bize değişiklik yapıldığında bildir diyoruz firestoreda.
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener
        { snapshot, error in
            if error != nil{
                print(error?.localizedDescription ?? "Error!")
            }
            else{
                //QuerySnapshot(Yukarıda snapshot olarak tanımladım) içerisinde koleksiyondan çektiğim dökümanlar bana veriliyor.Yaptığım değişiklikleri snapshotla görüyorum.
                //Documents dediğim zaman collection içindeki verileri array şeklinde alıyorum.
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            
                            self.userEmailArray.append(postedBy)
                            
                            if let commentText = document.get("commentText") as? String{
                                
                                self.userCommentArray.append(commentText)
                                
                                if let likes = document.get("likes") as? Int{
                                    
                                    self.likeArray.append(likes)
                                    
                                    if let imageUrl = document.get("imageUrl") as? String{
                                        self.userImageArray.append(imageUrl)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.commentTextLabel.text = userCommentArray[indexPath.row]
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
}
