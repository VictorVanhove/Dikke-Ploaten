//
//  ToastView.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 27/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	// MARK: - ToastAlert
	func showToast(controller: UIViewController, message : String, seconds: Double){
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.view.backgroundColor = .black
		alert.view.alpha = 0.1
		alert.view.layer.cornerRadius = 15
		
		controller.present(alert, animated: true)
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
			alert.dismiss(animated: true)
		}
		
	}
	
}
