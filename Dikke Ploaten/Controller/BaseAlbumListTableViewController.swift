//
//  BaseTableViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 28/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit

class BaseAlbumListTableViewController : UITableViewController {
	
	// MARK: - Properties
	var albums: [Album] = []
	
	var albumSection = [String]()
	var albumDictionary = [String: [Album]]()
	
	func generateWordsDict() {
		albumDictionary = [:]
		for album in albums {
			let key = String(album.artist.prefix(1))
			if albumDictionary[key] == nil {
				albumDictionary[key] = []
			}
			if !(albumDictionary[key]!.contains(album)){
				albumDictionary[key]!.append(album)
			}
		}
		
		albumSection = [String](albumDictionary.keys)
		albumSection = albumSection.sorted()
	}
	
	func checkIfEmpty() {
		if(albums.isEmpty){
			self.tableView.setEmptyMessage("Je hebt nog geen albums toegevoegd.\nGa naar de zoekfunctie en voeg albums toe!")
		} else {
			self.tableView.setEmptyMessage()
		}
		self.generateWordsDict()
		self.tableView.reloadData()
	}
	
	// MARK: - TableView
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return albumSection.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return albumSection[section]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return albumDictionary[albumSection[section]]?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
		
		let headerKey = albumSection[indexPath.section]
		
		if  let albumValue = albumDictionary[headerKey] {
			let album = albumValue[indexPath.row]
			
			cell.updateUI(forAlbum: album)
		}
		return cell
	}
	
	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return albumSection
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		let viewController = storyboard?.instantiateViewController(withIdentifier: "albumDetail") as! AlbumDetailViewController
		viewController.album = albumDictionary[albumSection[indexPath.section]]![indexPath.row]
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
}
