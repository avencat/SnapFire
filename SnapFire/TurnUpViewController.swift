//
//  TurnUpViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 06/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TurnUpViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passTextField: UITextField!
  @IBOutlet weak var turnUpButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
    loginTextField.delegate = self
    passTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    turnUpButton.isEnabled = true
  }
  
  @IBAction func turnUpTapped(_ sender: AnyObject) {
    
    if loginTextField.text != "" && passTextField.text != "" {
      turnUpButton.isEnabled = false
      
      FIRAuth.auth()?.signIn(withEmail: loginTextField.text!, password: passTextField.text!, completion: { (user, error) in
        if error != nil {
          FIRAuth.auth()?.createUser(withEmail: self.loginTextField.text!, password: self.passTextField.text!, completion: { (user, error) in
            if error != nil {
              print("Hey we have an error: \(error)")
            } else {
              FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
              self.performSegue(withIdentifier: "turnUpSegue", sender: nil)
            }
          })
        } else {
          self.performSegue(withIdentifier: "turnUpSegue", sender: nil)
        }
      })
    }
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == loginTextField {
      passTextField.select(textField)
    } else {
      self.view.endEditing(true)
      turnUpButton.sendActions(for: UIControlEvents.touchUpInside)
    }
    return true
  }
  
}

