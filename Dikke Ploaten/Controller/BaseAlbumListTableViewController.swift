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
	
	// MARK: - TableView Delegate
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [delete])
	}
	
	func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			//Removes selected album from list
			let album = self.albumDictionary[self.albumSection[indexPath.section]]![indexPath.row]
			Database.shared.deleteAlbum(albumId: album.id , completionHandler: { err in
				if let err = err {
					let alertController = UIAlertController(title: "Whoops", message: err.localizedDescription, preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
					self.present(alertController, animated: true, completion: nil)
					return
				}
				self.albums.remove(at: self.albums.firstIndex(of: album)!)
				self.generateWordsDict()
				self.tableView.reloadData()
			})
		}
		action.backgroundColor = .red
		return action
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
