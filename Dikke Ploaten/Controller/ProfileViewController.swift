//
//  ViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 09/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var imgBackgroundCover: UIImageView!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var lblUser: UILabel!
	
	@IBOutlet weak var tableView: UITableView!
	// MARK: - Properties
	var collectionAlbums: [Album] = []
	var wantlistAlbums: [Album] = []
	var collections = ["Collection", "Wantlist"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Removes additional empty cells in tableView
		tableView.tableFooterView = UIView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		Database.shared.getUser { user in
			self.lblUser.text = user.username
		}
		
		Database.shared.getUserPlates { (albums) in
			self.collectionAlbums = albums
			self.tableView.reloadData()
		}
		
		Database.shared.getUserWantlist { (albums) in
			self.wantlistAlbums = albums
			self.tableView.reloadData()
		}
		
		let storageRef = Storage.storage().reference(forURL: "gs://dikke-ploaten.appspot.com")
		let profileRef = storageRef.child("images/profile/\(Auth.auth().currentUser!.uid).jpg")
		profileRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
			if let error = error {
				print(error)
			} else {
				self.imgProfile.image = UIImage(data: data!)
			}
		}
		let coverRef = storageRef.child("images/cover/\(Auth.auth().currentUser!.uid).jpg")
		coverRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
			if let error = error {
				print(error)
			} else {
				self.imgBackgroundCover.image = UIImage(data: data!)
			}
		}
	}
	
}

extension ProfileViewController : UITableViewDelegate { }

extension ProfileViewController : UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return collections[section]
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return collections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CollectionHolderTableViewCell
		if indexPath.section == 0{
			if(!collectionAlbums.isEmpty){
				cell.updateAlbums(albums: collectionAlbums)
			}
		} else {
			if(!wantlistAlbums.isEmpty){
				cell.updateAlbums(albums: wantlistAlbums)
			}
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt
		indexPath: IndexPath) -> CGFloat
	{
		let itemsPerRow:CGFloat = 4
		let hardCodedPadding:CGFloat = 5
		let itemWidth = (tableView.bounds.width / itemsPerRow) - hardCodedPadding
		return itemWidth
	}
	
}
