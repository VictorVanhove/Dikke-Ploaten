//
//  ViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 09/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var imgBackgroundCover: UIImageView!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var lblUser: UILabel!
	
	var collections = ["Collection", "Wantlist"]
	
	override func viewDidLoad() {
		Database.shared.getUser { user in
			self.lblUser.text = user.username
		}
		
//		Database.shared.getUserPlates { (albums) in
//			self.collectionAlbums = albums
//			self.tableView.reloadData()
//		}
//
//		Database.shared.getUserWantlist { (albums) in
//			self.wantlistAlbums = albums
//			self.tableView.reloadData()
//		}
	}
	
}

extension ViewController : UITableViewDelegate { }

extension ViewController : UITableViewDataSource {
	
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
		return cell
	}
	
}
