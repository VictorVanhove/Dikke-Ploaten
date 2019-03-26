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

class CollectionViewController: UITableViewController {
	
    // MARK: - Properties
    var albums: [Album] = []
    // Firebase
    let db = Firestore.firestore()
    
    var albumSection = [String]()
    var albumDictionary = [String: [Album]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets data from database and updates on changes
        Database().updateCollection(albums: albums) { albums in
            self.albums = albums
            self.generateWordsDict()
            self.tableView.reloadData()
        }
        
    }
    
    func generateWordsDict() {
        for album in albums {
            let key = String(album.artist.prefix(1))
			if albumDictionary[key] == nil {
				albumDictionary[key] = []
			}
			albumDictionary[key]!.append(album)
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
			// TODO: Database
            self.db.collection("userPlaten").document(self.albums[indexPath.row].id).delete() { err in
                if let err = err {
					print(err)
                    print("Error removing document: \(err.localizedDescription)")
					// TODO: UIAlertController
                } else {
                    print("Document successfully removed!")
					self.albums.remove(at: indexPath.row)
					self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
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
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

