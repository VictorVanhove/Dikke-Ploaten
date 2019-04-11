//
//  SettingsTableViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 21/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController : UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblEmail: UILabel!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var imgBackgroundCover: UIImageView!
	
	let imagePicker = UIImagePickerController()
	var isPickingImageForProfile = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imagePicker.delegate = self
		
		Database.shared.getUser { user in
			self.lblName.text = user.username
			self.lblEmail.text = user.email
		}
		
		Database.shared.getProfileImage { data in
			self.imgProfile.image = UIImage(data: data)
			self.imgProfile.contentMode = .scaleAspectFit
		}
		Database.shared.getProfileCover { data in
			self.imgBackgroundCover.image = UIImage(data: data)
			self.imgBackgroundCover.contentMode = .scaleAspectFit
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
	
	// MARK: - UIImagePickerControllerDelegate Methods
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			if(isPickingImageForProfile) {
				imgProfile.contentMode = .scaleAspectFit
				imgProfile.image = image
			} else {
				imgBackgroundCover.contentMode = .scaleAspectFit
				imgBackgroundCover.image = image
			}
		}
		if(isPickingImageForProfile) {
			Database.shared.uploadImage(image: imgProfile.image!, asProfileImage: true)
			isPickingImageForProfile = false
		} else {
			Database.shared.uploadImage(image: imgBackgroundCover.image!, asProfileImage: false)
		}
		
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - TableView
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				isPickingImageForProfile = true
			}
			imagePicker.allowsEditing = false
			imagePicker.sourceType = .photoLibrary
			
			present(imagePicker, animated: true, completion: nil)
			
		}
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
				alertController.addTextField { textField in
					textField.placeholder = "Nieuw wachtwoord"
					textField.isSecureTextEntry = true
				}
				alertController.addTextField { textField in
					textField.placeholder = "Bevestig nieuw wachtwoord"
					textField.isSecureTextEntry = true
				}
				let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
					guard let alertController = alertController, let textField1 = alertController.textFields?.first, let textField2 = alertController.textFields?.last  else { return }
					if(textField1.text == textField2.text){
						Database.shared.updatePassword(newPassword: textField2.text!, completionHandler: { err in
							if let err = err {
								print(err)
							}
							Database.shared.getUser { user in
								self.lblName.text = user.username
								self.lblEmail.text = user.email
							}
						})
					}
				}
				alertController.addAction(confirmAction)
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
				alertController.addAction(cancelAction)
				present(alertController, animated: true, completion: nil)
			}
		}
		
	}
}
