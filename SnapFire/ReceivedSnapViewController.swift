//
//  ReceivedSnapViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 13/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit

class ReceivedSnapViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  var snap : Snap?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    descriptionLabel.text = snap?.description
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    imageView.image = UIImage(data: NSData(contentsOf: URL(string: (snap?.imageUrl)!)!) as! Data)
  }
  
}
