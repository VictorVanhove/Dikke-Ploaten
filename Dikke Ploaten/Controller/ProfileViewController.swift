//
//  ProfileViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var imgBackgroundCover: UIImageView!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var lblUser: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Database.shared.getUser { user in
			print(user)
			self.lblUser.text = user.username
		}
		
		imgProfile.layer.borderWidth = 1
		imgProfile.layer.masksToBounds = false
		imgProfile.layer.borderColor = UIColor.black.cgColor
		imgProfile.layer.cornerRadius = imgProfile.frame.height/2
		imgProfile.clipsToBounds = true
		
	}
	
}
