//
//  SnapsViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 10/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var snapsTableView: UITableView!
  
  var snaps : [Snap] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    snapsTableView.delegate = self
    snapsTableView.dataSource = self
    
    FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snaps").observe(FIRDataEventType.childAdded, with: { (snapshot) in
      let snap = Snap()
      
      snap.sender = (snapshot.value as! NSDictionary)["from"] as! String
      snap.description = (snapshot.value as! NSDictionary)["description"] as! String
      snap.imageUrl = (snapshot.value as! NSDictionary)["imageURL"] as! String
      snap.uid = snapshot.key
      snap.imageUUID = (snapshot.value as! NSDictionary)["imageUUID"] as! String
      
      self.snaps.append(snap)
      
      self.snapsTableView.reloadData()
    })

    FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snaps").observe(FIRDataEventType.childRemoved, with: { (snapshot) in
      
      var i = 0
      for snap in self.snaps {
        if snap.uid == snapshot.key {
          self.snaps.remove(at: i)
        }
        
        i += 1
      }
      
      self.snapsTableView.reloadData()
    })
  }
  
  @IBAction func logOutTapped(_ sender: AnyObject) {
    dismiss(animated: true) {
      do {
        try FIRAuth.auth()?.signOut()
      } catch {
        print("Error while trying to sign out.")
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if snaps.count == 0 {
      return 1
    }
    
    return snaps.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    if snaps.count == 0 {
      cell.textLabel?.text = "You have no snaps ! ☹️"
    } else {
      cell.textLabel?.text = snaps[indexPath.row].sender
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let snap = snaps[indexPath.row]
    
    performSegue(withIdentifier: "receivedSnapSegue", sender: snap)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "receivedSnapSegue" {
      let nextVC = segue.destination as! ReceivedSnapViewController
      
      nextVC.snap = sender as? Snap
    }
  }
}
