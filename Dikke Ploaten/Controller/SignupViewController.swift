//
//  SignupViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var lblEmail: UILabel!
	@IBOutlet weak var txtEmail: UITextField!
	@IBOutlet weak var lblUser: UILabel!
	@IBOutlet weak var txtUser: UITextField!
	@IBOutlet weak var lblPassword: UILabel!
	@IBOutlet weak var txtPassword: UITextField!
	weak var activeField: UITextField?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Add observers
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// Remove observers
		NotificationCenter.default.removeObserver(keyboardWillShow)
		NotificationCenter.default.removeObserver(keyboardWillHide)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.activeField = nil
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.activeField = textField
	}
	
	// Change size of scrollView and scroll to field
	@objc func keyboardWillShow(notification: NSNotification) {
		if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			var aRect = self.view.frame
			aRect.size.height -= keyboardSize.size.height
			if !aRect.contains(activeField.frame.origin) {
				self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
			}
		}
	}
	
	// Undo the above
	@objc func keyboardWillHide(notification: NSNotification) {
		let contentInsets = UIEdgeInsets.zero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}
	
	// MARK: - Actions
	@IBAction func signUpUser(_ sender: Any) {
		if validForm() {
			Database.shared.createUser(username: txtUser.text ?? "", email: txtEmail.text ?? "", password: txtPassword.text ?? "", successHandler: {
				// Go to next view
				self.performSegue(withIdentifier: "signupToHome", sender: self)
			}, failureHandler: { error in
				// Error creating user
				let err = (error as NSError).userInfo["error_name"]! as! String
				var alertMessage = NSLocalizedString("", comment: "")
				if err == "ERROR_INVALID_EMAIL" {
					print(err)
					alertMessage = "bad_email".localized()
				}
				if err == "ERROR_WEAK_PASSWORD" {
					print(err)
					alertMessage = "invalid_password".localized()
				}
				if err == "ERROR_EMAIL_ALREADY_IN_USE" {
					print(err)
					alertMessage = "email_already_in_use".localized()
				}
				let alertController = UIAlertController(title: "whoops".localized(), message: alertMessage, preferredStyle: .alert)
				let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				
				alertController.addAction(defaultAction)
				self.present(alertController, animated: true, completion: nil)
			})
		}
	}
	
	// MARK: - Controlling the keyboard
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case txtUser:
			txtEmail.becomeFirstResponder()
		case txtEmail:
			txtPassword.becomeFirstResponder()
		default:
			textField.resignFirstResponder()
			signUpUser(textField)
		}
		return true
	}
	
	// Check if form is valid
	private func validForm() -> Bool {
		// Check name
		lblUser.textColor = UIColor.black
		if !txtUser.text!.isEmpty {
			// Check email
			lblEmail.textColor = UIColor.black
			if !txtEmail.text!.isEmpty {
				// Check password
				lblPassword.textColor = UIColor.black
				if !txtPassword.text!.isEmpty {
					return true
				}
			}
		}
		
		// Show alert if form is not filled in correctly
		let alertController = UIAlertController(title: "whoops".localized(), message: "fields_not_all_filled".localized(), preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		self.present(alertController, animated: true, completion: nil)
		
		return false
	}
	
}
