//
//  AlbumCollectionViewCell.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 04/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumCollectionViewCell : UICollectionViewCell {
	
	@IBOutlet weak var imgCover: UIImageView!
	
	func updateUI(forAlbum album: Album){
		imgCover.af_setImage(withURL: URL(string: album.cover)!)
	}
	
	
}
