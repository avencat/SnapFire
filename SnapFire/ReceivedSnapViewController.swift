//
//  ReceivedSnapViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 13/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ReceivedSnapViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!

  var snap : Snap?
  var usersUID: [String] = []
  var isRemovable = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    descriptionLabel.text = snap?.description
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    imageView.image = UIImage(data: NSData(contentsOf: URL(string: (snap?.imageUrl)!)!) as! Data)
    
    FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
      
      self.usersUID.append(snapshot.key)
      
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap!.uid).removeValue()
    
    for user in usersUID {
      if user != FIRAuth.auth()!.currentUser!.uid {
        FIRDatabase.database().reference().child("users").child(user).child("snaps").observe(FIRDataEventType.childAdded, with: { (snapshot) in
          if (snapshot.value as! NSDictionary)["imageURL"]! as! String == self.snap!.imageUrl {
            self.isRemovable = false
          }
        })
      }
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if isRemovable == true {
      FIRStorage.storage().reference().child("images").child("\(snap!.imageUUID).jpg").delete(completion: { (error) in
        if error != nil {
          print("Something went wrong when trying to delete \(self.snap!.imageUUID).jpg : \(error)")
        }
      })
    }
  }
  
}
