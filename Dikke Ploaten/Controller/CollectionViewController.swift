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
		Database.shared.getUserPlates { albums in
			self.albums = albums
			self.reloadTableView()
		}
	}
	
	// MARK: - TableView Delegate
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [delete])
	}
	
	func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
		
		let action = UIContextualAction(style: .destructive, title: "\u{232B}\n" + "remove".localized()) { _, _, completion in
			//Removes selected album from list
			let album = self.albumDictionary[self.albumSection[indexPath.section]]![indexPath.row]
			Database.shared.deleteCollectionAlbum(albumId: album.id, completionHandler: { err in
				if let err = err { 
					let alertController = UIAlertController(title: "whoops".localized(), message: err.localizedDescription, preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
					self.present(alertController, animated: true, completion: nil)
					return
				}
				self.albums.remove(at: self.albums.firstIndex(of: album)!)
				self.reloadTableView()
				
				//Show toast alert
				let alertMessage = "is_removed_from_collection".localized().replacingOccurrences(of: "%album", with: album.title).replacingOccurrences(of: "%artist", with: album.artist)
				self.showToast(controller: self, message: alertMessage, seconds: 2)
			})
		}
		action.backgroundColor = .red
		return action
	}
	
}
