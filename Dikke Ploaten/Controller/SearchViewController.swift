//
//  SearchViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import OrderedSet

class SearchViewController: UITableViewController, UISearchResultsUpdating {
	
	// MARK: - Properties
	//var albums: OrderedSet<Album> = []
	var albums = [Album]()
	var filteredAlbums = [Album]()
	var resultSearchController = UISearchController()
	
	// Firebase
	let db = Firestore.firestore()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Gets all albums from database
		Database().getAlbumList(albums: albums) { (albums) in
			self.albums = albums
			self.tableView.reloadData()
		}
		
		resultSearchController = ({
			let controller = UISearchController(searchResultsController: nil)
			controller.searchResultsUpdater = self
			controller.dimsBackgroundDuringPresentation = false
			controller.searchBar.sizeToFit()
			
			tableView.tableHeaderView = controller.searchBar
			
			return controller
		})()
		
		// Reload the table
		tableView.reloadData()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		filteredAlbums = albums.filter{ ($0.title.contains(searchController.searchBar.text!)) }
		self.tableView.reloadData()
	}
	
	// MARK: - Table View
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1//albums.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if  (resultSearchController.isActive) {
			return filteredAlbums.count
		} else {
			return albums.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
		
		var album = albums[indexPath.row]
		
		if (resultSearchController.isActive) {
			album = filteredAlbums[indexPath.row]
		}
		
		cell.lblTitle.text = album.title
		cell.lblArtist.text = album.artist
		cell.imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
		//        if Auth.auth().currentUser?.uid == album.userID {
		//            cell.btnRemove.isEnabled = true
		//        }
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
		
		let add = UITableViewRowAction(style: .normal, title: "Add") { action, index in
			let album = self.albums[index.row]
			album.userID = Auth.auth().currentUser?.uid
			// Write instance to database
			Database().addToDatabase(album: album)
		}
		add.backgroundColor = UIColor(red:0.11, green:0.74, blue:0.61, alpha:1.0)
		
		return [add]
	}
	
}




