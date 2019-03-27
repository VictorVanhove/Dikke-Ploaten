//
//  LaunchViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 20/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class LaunchViewController : UIViewController {
    
    @IBOutlet weak var imgVinyl: UIImageView!

    var vinylImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        vinylImages = createImageArray(total: 35, imagePrefix: "vinyl")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate(imageView: imgVinyl, images: vinylImages)
		
        //If already logged in, go to mainscreen
         if Database().isUserLoggedIn() {
			// Go to mainview
			self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
		
		// TODO: data prefetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "gotoLogin", sender: nil)
        }
    }

    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []

        for imageCount in 1..<total {
            let imageName = "\(imagePrefix)\(imageCount)"
            let image = UIImage(named: imageName)!

            imageArray.append(image)
        }

        return imageArray
    }

    func animate(imageView: UIImageView, images: [UIImage]){
        imageView.animationImages = images
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = 2
        imageView.startAnimating()
    }
}
