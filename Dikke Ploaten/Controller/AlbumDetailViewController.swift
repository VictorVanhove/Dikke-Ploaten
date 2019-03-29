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
	@IBOutlet weak var txtDescription: UITextView!
	@IBOutlet weak var lblGenre: UILabel!
	@IBOutlet weak var lblReleaseYear: UILabel!
	@IBOutlet weak var txtTracklist: UITextView!
	@IBOutlet weak var txtMusicians: UITextView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		lblTitle.text = album.title
		lblArtist.text = album.artist
		imgCover.image = UIImage(data: try! Data(contentsOf: URL(string: album.cover)!))
		txtDescription.text = album.description ?? "blabla"
		lblGenre.text = album.genre ?? "Rock"
		lblReleaseYear.text = album.releaseYear ?? "Juli 1979"
		txtTracklist.text = album.tracklist?.replacingOccurrences(of: "\\n", with: "\n") ?? ""
		txtMusicians.text = album.musicians?.replacingOccurrences(of: "\\n", with: "\n") ?? ""
	}
	
}
