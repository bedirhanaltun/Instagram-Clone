//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Bedirhan Altun on 3.08.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var settingsArray = ["Follow and Invite Friends","Notifications","Privacy","Security","Ads","Payment","Account","Help","About"]
    var settingsImageArray : [UIImage] = [UIImage(named: "followfriends")!, UIImage(named: "not")!,UIImage(named: "privacy")!,
    UIImage(named: "security")!,UIImage(named: "ad")!,UIImage(named: "pay")!,UIImage(named: "account")!,UIImage(named: "help")!,UIImage(named: "information")!]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 48
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    @IBAction func logOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }
        catch{
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = settingsArray[indexPath.row]
        let image : UIImage = settingsImageArray[indexPath.row]
        let rect = CGRect(x: 2, y: 2, width: 2, height: 2)
        image.draw(in: rect)
        cell.imageView?.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    
    
}
