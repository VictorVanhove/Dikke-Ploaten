//
//  SecondViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 13/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

//A lot of duplicate code (see CollectionViewController), best way to solve this?
class WantlistViewController: BaseAlbumListTableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Gets data from database and updates on changes
		Database.shared.addWantlistChangeListener(albums: albums) { albums in
			self.albums = albums
			self.generateWordsDict()
			self.tableView.reloadData()
		}
	}
	
}

