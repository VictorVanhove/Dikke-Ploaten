//
//  FirstViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 13/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

class CollectionViewController: BaseAlbumListTableViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		// Gets data from database and updates on changes
		Database.shared.getUserPlates { (albums) in
			self.albums = albums
			self.generateWordsDict()
			self.tableView.reloadData()
		}
	}
	
}

