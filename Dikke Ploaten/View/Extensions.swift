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
	func showToast(controller: UIViewController, message: String, seconds: Double) {
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

extension UITableView {
	
	func setEmptyMessage(_ message: String? = nil) {
		guard let message = message else {
			self.backgroundView = nil
			self.separatorStyle = .singleLine
			return
		}
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
		messageLabel.text = message
		messageLabel.textColor = .black
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
		messageLabel.sizeToFit()
		
		self.backgroundView = messageLabel
		self.separatorStyle = .none
	}
	
}

extension String {
	
	func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
		return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
	}
}
