//
//  CollectionTableViewCell.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    
    
    
    let db = Firestore.firestore()
    
    func updateCell(forAlbum album: Album){
        lblTitle.text = album.title
        lblArtist.text = album.artist
        imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
    }
    
}
