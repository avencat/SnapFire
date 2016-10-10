//
//  UsersViewController.swift
//  SnapFire
//
//  Created by Axel Vencatareddy on 10/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var usersTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usersTableView.delegate = self
    usersTableView.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    <#code#>
  }
}
