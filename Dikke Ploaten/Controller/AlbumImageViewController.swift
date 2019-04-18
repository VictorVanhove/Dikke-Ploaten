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
		slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFit
		
		let pageControl = UIPageControl()
		pageControl.currentPageIndicatorTintColor = UIColor.lightGray
		pageControl.pageIndicatorTintColor = UIColor.black
		slideshow.pageIndicator = pageControl
		
		slideshow.activityIndicator = DefaultActivityIndicator()
		
		var alamofireSource = [AlamofireSource]()
		
		for image in album.images {
			alamofireSource.append(AlamofireSource(urlString: image)!)
		}
		
		slideshow.setImageInputs(alamofireSource)
	}
	
}
