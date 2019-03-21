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
        //cell.updateCell(forAlbum: albums[indexPath.row])
        
        var album = albums[indexPath.row]
        
        if (resultSearchController.isActive) {
            album = filteredAlbums[indexPath.row]
        }
        
        cell.lblTitle.text = album.title
        cell.lblArtist.text = album.artist
        cell.imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
        return cell
    }
    
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return albums.count
    //    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
    //        //cell.updateCell(forAlbum: albums[indexPath.row])
    //
    //        let album = albums[indexPath.row]
    //        cell.lblTitle.text = album.title
    //        cell.lblArtist.text = album.artist
    //        cell.imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
    //        return cell
    //    }
    
}




