//
//  SettingsTableViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 21/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController : UITableViewController {
	
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblEmail: UILabel!
	@IBOutlet weak var lblPassword: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Database.shared.getUser { user in
			self.lblName.text = user.username
			self.lblEmail.text = user.email
			self.lblPassword.text = user.password
		}
		
	}
	
	@IBAction func signOutUser(_ sender: Any) {
		// Sign out
		do {
			try Auth.auth().signOut()
		}
		catch {
			print ("Error signing out: %@", error)
		}
		
		// Go back to initial view
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let initial = storyboard.instantiateInitialViewController()
		UIApplication.shared.keyWindow?.rootViewController = initial
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		
		if indexPath.section == 1 {
			if indexPath.row == 0 {
				let alertController = UIAlertController(title: "Verander naam", message: "Verander hier je gebruikersnaam:", preferredStyle: .alert)
				alertController.addTextField { textField in
					textField.placeholder = "Gebruikersnaam"
				}
				let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
					guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
					Database.shared.updateUsername(username: textField.text!, completionHandler: { err in
						if let err = err {
							print(err)
						}
						Database.shared.getUser { user in
							self.lblName.text = user.username
							self.lblEmail.text = user.email
							self.lblPassword.text = user.password
						}
					})
				}
				alertController.addAction(confirmAction)
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				alertController.addAction(cancelAction)
				present(alertController, animated: true, completion: nil)
			}
			if indexPath.row == 1{
				let alertController = UIAlertController(title: "Verander wachtwoord", message: "Verander hier je wachtwoord:", preferredStyle: .alert)
				//				alertController.addTextField { textField in
				//					textField.placeholder = "Oud wachtwoord"
				//					textField.isSecureTextEntry = true
				//				}
				alertController.addTextField { textField in
					textField.placeholder = "Nieuw wachtwoord"
					textField.isSecureTextEntry = true
				}
				let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
					guard let alertController = alertController/*, let textField1 = alertController.textFields?.first*/, let textField2 = alertController.textFields?.last else { return }
					print("New password \(String(describing: textField2.text))")
					Database.shared.updatePassword(newPassword: textField2.text!, completionHandler: { err in
						if let err = err {
							print(err)
						}
						Database.shared.getUser { user in
							self.lblName.text = user.username
							self.lblEmail.text = user.email
							self.lblPassword.text = user.password
						}
					})
				}
				alertController.addAction(confirmAction)
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				alertController.addAction(cancelAction)
				present(alertController, animated: true, completion: nil)
			}
		}
		
	}
}
