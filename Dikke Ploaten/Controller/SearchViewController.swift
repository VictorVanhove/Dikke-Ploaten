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

class SearchViewController: UITableViewController {
    
    // MARK: - Properties
    var albums: OrderedSet<Album> = []
    // Firebase


    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        
        db.collection("platen").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let album = try! Mapper<Album>().map(JSON: document.data())
                    album.setId(id: document.documentID)
                    self.albums.append(album)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: false)
    //        performSegue(withIdentifier: "showPopUp", sender: indexPath)
    //    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return contact[section].uppercased()
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
        cell.updateCell(forAlbum: albums[indexPath.row])
        return cell
    }

}

