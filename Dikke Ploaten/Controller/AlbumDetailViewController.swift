//
//  AlbumDetailViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 28/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
	
	var album : Album!
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblArtist: UILabel!
	@IBOutlet weak var imgCover: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		lblTitle.text = album.title
		lblArtist.text = album.artist
		imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
	}
	
}
