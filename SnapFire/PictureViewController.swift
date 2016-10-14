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
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var nextButton: UIButton!
  
  var imagePicker = UIImagePickerController()
  let uuid = NSUUID().uuidString

  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self
  }
  
  @IBAction func cameraTapped(_ sender: AnyObject) {
    imagePicker.sourceType = .savedPhotosAlbum
    imagePicker.allowsEditing = true

    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func nextButtonTapped(_ sender: AnyObject) {
    
    nextButton.isEnabled = false
    
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
    let image = info[UIImagePickerControllerEditedImage] as! UIImage
    
    imageView.image = image
    
    imageView.backgroundColor = UIColor.clear
    
    imagePicker.dismiss(animated: true, completion: nil)
  }
}
