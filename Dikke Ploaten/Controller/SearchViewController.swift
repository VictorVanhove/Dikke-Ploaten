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
	
	var albums = [Album]()
	var filteredAlbums = [Album]()
	
	let searchController = UISearchController(searchResultsController: nil)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Add searchbar to nav
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.sizeToFit()
		self.navigationItem.titleView = searchController.searchBar
		
		// Gets all albums from database
		Database().getAlbumList(albums: albums) { (albums) in
			self.albums = albums
			self.tableView.reloadData()
		}
		
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
		if  (searchController.isActive) {
			return filteredAlbums.count
		} else {
			return albums.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
		
		var album = albums[indexPath.row]
		
		if (searchController.isActive) {
			album = filteredAlbums[indexPath.row]
		}
		
		cell.lblTitle.text = album.title
		cell.lblArtist.text = album.artist
		cell.imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let add = UITableViewRowAction(style: .default, title: "Add", handler: {
			(action, index) in
			let album = self.albums[index.row]
			album.userID = Auth.auth().currentUser?.uid
			// Write instance to database
			Database().addToCollection(album: album, failureHandler: { err in
				if let err = err {
					print(err)
					// TODO Alert
					return
				}
			})
			//Show toast alert
			self.showToast(controller: self, message: "'\(album.title)' by \(album.artist) added to your collection", seconds: 1)
		})
		add.backgroundColor = UIColor(red:0.11, green:0.74, blue:0.61, alpha:1.0)
		
		let want = UITableViewRowAction(style: .default, title: "Want", handler: {
			(action, index) in
			let album = self.albums[index.row]
			album.userID = Auth.auth().currentUser?.uid
			// Write instance to database
			Database().addToWantlist(album: album, failureHandler: { err in
				if let err = err {
					print(err)
					//TODO Alert
					return
				}
			})
			//Show toast alert
			self.showToast(controller: self, message: "'\(album.title)' by \(album.artist) added to your wantlist", seconds: 1)
		})
		want.backgroundColor = UIColor(red:1.00, green:0.65, blue:0.00, alpha:1.0)
		
		return [add, want]
	}
	
}




