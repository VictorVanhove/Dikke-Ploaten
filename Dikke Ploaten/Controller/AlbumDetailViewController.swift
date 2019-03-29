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
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	
	var imageArray = [UIImage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Temporarily in to show images
		imageArray = [UIImage(data: try! Data(contentsOf: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music5/v4/c9/24/30/c92430dd-1371-46c5-9ef0-df89ca5c3687/UMG_cvrart_00602547297433_01_RGB72_1500x1500_13UABIM03512.jpg/600x600bf.png")!)),
					  UIImage(data: try! Data(contentsOf: URL(string: "https://img.discogs.com/YzBmkm1KJWK92POeVtVnc-vM7J4=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1354479-1346387042-8713.jpeg.jpg")!)),
					  UIImage(data: try! Data(contentsOf: URL(string: "https://img.discogs.com/78ldaZu19j29m2UTQqXK6U5nBLU=/fit-in/500x500/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1354479-1340740432-9572.jpeg.jpg")!)),
					  UIImage(data: try! Data(contentsOf: URL(string: "https://img.discogs.com/tLdTA_cVoJqCUTdHrsjZF2soATw=/fit-in/500x500/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1354479-1340740438-4981.jpeg.jpg")!))
					  ] as! [UIImage]
		
		lblTitle.text = album.title
		lblArtist.text = album.artist
		setupImages(imageArray)
		txtDescription.text = album.description ?? "blabla"
		lblGenre.text = album.genre ?? "Rock"
		lblReleaseYear.text = album.releaseYear ?? "Juli 1979"
		txtTracklist.text = album.tracklist?.replacingOccurrences(of: "\\n", with: "\n") ?? ""
		txtMusicians.text = album.musicians?.replacingOccurrences(of: "\\n", with: "\n") ?? ""
	}

	// Adds images in array
	func setupImages(_ images: [UIImage]){
		
		for i in 0..<images.count {
			let imageView = UIImageView()
			let x = self.view.frame.size.width * CGFloat(i)
			imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: 375)
			imageView.image = images[i]
			scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
			scrollView.addSubview(imageView)
		}
		
	}
	
}
