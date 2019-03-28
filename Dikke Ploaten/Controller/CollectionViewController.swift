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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Gets data from database and updates on changes
		Database.shared.addCollectionChangeListener(albums: albums) { albums in
			self.albums = albums
			self.generateWordsDict()
			self.tableView.reloadData()
		}
		
	}
	
	// MARK: - TableView Delegate
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [delete])
	}
	
	func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
			//Removes selected album from list
			let album = self.albums[indexPath.row]
			Database.shared.deleteAlbum(albumId: album.id , completionHandler: { err in
				if let err = err {
					let alertController = UIAlertController(title: "Whoops", message: err.localizedDescription, preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
					self.present(alertController, animated: true, completion: nil)
				}
				self.tableView.reloadData()
			})
		}
		action.backgroundColor = .red
		return action
	}
	
}

