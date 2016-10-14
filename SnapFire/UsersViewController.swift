//
//  UsersViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 10/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var usersTableView: UITableView!
  
  var users : [User] = []
  
  var imageURL = ""
  var imageDescription = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usersTableView.delegate = self
    usersTableView.dataSource = self
    
    FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
      let user = User()
      
      user.email = (snapshot.value as! NSDictionary)["email"] as! String
      user.uid = snapshot.key
      
      self.users.append(user)
      
      self.usersTableView.reloadData()
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    cell.textLabel?.text = users[indexPath.row].email
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = users[indexPath.row]
    
    let snap = ["from": (FIRAuth.auth()?.currentUser?.email!)!, "description": imageDescription, "imageURL": imageURL]
    
    FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
  }
}
