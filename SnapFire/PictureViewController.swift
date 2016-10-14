//
//  PictureViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 10/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
  @IBOutlet weak var layout: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var nextButton: UIButton!
  
  var originalButtonsColor = UIColor.clear
  
  var imagePicker = UIImagePickerController()
  var uuid = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
    imagePicker.delegate = self
    
    loadingWheel.hidesWhenStopped = true
    originalButtonsColor = nextButton.tintColor!
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadingWheel.stopAnimating()
    layout.isHidden = true
    if imageView.image == nil {
      nextButton.isEnabled = false
    } else {
      nextButton.isEnabled = true
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationBar.isUserInteractionEnabled = true
    navigationController?.navigationBar.tintColor = originalButtonsColor
  }
  
  @IBAction func cameraTapped(_ sender: AnyObject) {
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = false

    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func nextButtonTapped(_ sender: AnyObject) {

    nextButton.isEnabled = false
    
    navigationController?.navigationBar.isUserInteractionEnabled = false
    navigationController?.navigationBar.tintColor = UIColor.init(colorLiteralRed: 0.82, green: 0.82, blue: 0.82, alpha: 1)

    layout.isHidden = false
    loadingWheel.startAnimating()
    loadingWheel.hidesWhenStopped = true
    
    let imagesDir = FIRStorage.storage().reference().child("images")
    
    let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
    
    imagesDir.child("\(uuid).jpg").put(imageData, metadata: nil) { (metadata, error) in
      if error != nil {
        print("We have an error: \(error)")
      } else {
        self.performSegue(withIdentifier: "selectUsersSegue", sender: metadata?.downloadURL()?.absoluteString)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nextVC = segue.destination as! UsersViewController
    
    nextVC.imageURL = sender as! String
    nextVC.imageDescription = descriptionTextField.text!
    nextVC.uuid = uuid
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    
    imageView.image = image
    
    imageView.backgroundColor = UIColor.clear
    
    imagePicker.dismiss(animated: true, completion: nil)
    
    uuid = NSUUID().uuidString
    
    nextButton.isEnabled = true
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
