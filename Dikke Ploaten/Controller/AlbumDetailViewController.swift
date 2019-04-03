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
	@IBOutlet weak var txtDescription: UILabel!
	@IBOutlet weak var lblGenre: UILabel!
	@IBOutlet weak var lblReleaseYear: UILabel!
	@IBOutlet weak var txtTracklist: UITextView!
	@IBOutlet weak var txtMusicians: UITextView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		lblTitle.text = album.title
		lblArtist.text = album.artist
		imgCover.af_setImage(withURL: URL(string: album.cover)!)
		imgCover.contentMode = .scaleAspectFill
		txtDescription.text = album.description
		lblGenre.text = album.genre
		lblReleaseYear.text = album.releaseYear
		txtTracklist.text = album.tracklist.replacingOccurrences(of: "\\n", with: "\n")
		txtMusicians.text = album.musicians.replacingOccurrences(of: "\\n", with: "\n")
	}
	
	@IBAction func showMoreImages(_ sender: Any) {
			performSegue(withIdentifier: "showMoreImages", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let albumImageViewController = segue.destination as! AlbumImageViewController
		albumImageViewController.album = album
	}
	
}
