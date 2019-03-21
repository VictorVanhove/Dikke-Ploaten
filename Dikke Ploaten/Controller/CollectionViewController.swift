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
import OrderedSet

class CollectionViewController: UITableViewController {
    
    // MARK: - Properties
    var albums: OrderedSet<Album> = []
    var artists: [String] = []
    // Firebase
    
    var contactSection = [String]()
    var contactDictionary = [String : [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        
        db.collection("platen").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let album = try! Mapper<Album>().map(JSON: document.data())
                    album.setId(id: document.documentID)
                    self.albums.append(album)
                    self.artists.append(album.artist)
                    self.tableView.reloadData()
                }
            }
            self.generateWordsDict()
        }
        
    }
    
    func generateWordsDict(){
        for artist in artists {
            let key = String(artist.prefix(1))
            if var contactValue = contactDictionary[key]
            {
                contactValue.append(artist)
            }else{
                contactDictionary[key] = [artist]
            }
        }
        contactSection = [String](contactDictionary.keys)
        contactSection = contactSection.sorted()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactSection[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactKey = contactSection[section]
        if let contactValue = contactDictionary[contactKey]{
            return contactValue.count
        }
        return 0
        //return albums.count
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: false)
    //        performSegue(withIdentifier: "showPopUp", sender: indexPath)
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
        
        let headerKey = contactSection[indexPath.section]
        
        if  let contactValue = contactDictionary[headerKey] {
            //cell.updateCell(forAlbum: albums[indexPath.row])
            cell.lblArtist.text = contactValue[indexPath.row]
        }
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactSection
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = contactSection.index(of: title) else {
            return -1
        }
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

