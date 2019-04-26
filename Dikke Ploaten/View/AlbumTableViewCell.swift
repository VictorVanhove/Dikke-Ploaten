//
//  CollectionTableViewCell.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class AlbumTableViewCell: UITableViewCell {
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblArtist: UILabel!
	@IBOutlet weak var imgCover: UIImageView!
	
	@IBOutlet weak var imgNotifier: UIImageView!
	
	let template = URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg")
	
	func updateUI(forAlbum album: Album) {
		lblTitle.text = album.title
		lblArtist.text = album.artist
		imgCover.af_setImage(withURL: URL(string: album.cover) ?? template!)
	}
	
	func updateUISearch(forAlbum album: Album, image: String? = nil) {
		lblTitle.text = album.title
		lblArtist.text = album.artist
		imgCover.af_setImage(withURL: URL(string: album.cover) ?? template!)
		if image != nil {
			imgNotifier.image = UIImage(named: image!)
		} else {
			imgNotifier.image = UIImage(named: "notInCollection")
		}
	}
}
