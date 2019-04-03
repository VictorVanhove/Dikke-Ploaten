//
//  AlbumImageViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 02/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import ImageSlideshow

class AlbumImageViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet var slideshow: ImageSlideshow!

	var album: Album!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
		slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
		
		let pageControl = UIPageControl()
		pageControl.currentPageIndicatorTintColor = UIColor.lightGray
		pageControl.pageIndicatorTintColor = UIColor.black
		slideshow.pageIndicator = pageControl
		
		// optional way to show activity indicator during image load (skipping the line will show no activity indicator)
		slideshow.activityIndicator = DefaultActivityIndicator()
		
		var alamofireSource = [AlamofireSource]()

		for i in 0..<album.images.count {
			alamofireSource.append(AlamofireSource(urlString: album.images[i])!)
		}
		
		slideshow.setImageInputs(alamofireSource)
	}


}
