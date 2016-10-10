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

class SnapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
