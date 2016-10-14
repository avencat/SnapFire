//
//  UsersViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 10/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var usersTableView: UITableView!
  
  var users : [User] = []
  
  var imageURL = ""
  var imageDescription = ""
  var uuid = ""
  var isRemovable = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usersTableView.delegate = self
    usersTableView.dataSource = self
    
    doneButton.tintColor = UIColor(colorLiteralRed: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    doneButton.isEnabled = false
    
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
    
    let snap = ["from": (FIRAuth.auth()?.currentUser?.email!)!, "description": imageDescription, "imageURL": imageURL, "imageUUID": uuid]
    
    FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
    
    isRemovable = false
    doneButton.isEnabled = true
    doneButton.tintColor = nil
  }

  @IBAction func doneTapped(_ sender: AnyObject) {
    if doneButton.isEnabled {
      navigationController!.popToRootViewController(animated: true)
    }
  }
  
  override func viewWillDisappear(_ animated : Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParentViewController && isRemovable {
      FIRStorage.storage().reference().child("images").child("\(uuid).jpg").delete(completion: { (error) in
        if error != nil {
          print("Something went wrong when trying to delete \(self.uuid).jpg : \(error)")
        }
      })
    }
  }
}
