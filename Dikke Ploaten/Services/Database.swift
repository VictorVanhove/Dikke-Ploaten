//
//  Database.swift
//  Dikke Ploaten
//
//  Created by Wim Van Renterghem on 26/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase

class Database {
	
	// TODO: completionhandler
	func addToDatabase(album: Album) {
		// Data from object in JSON
		let data = album.toJSON()
		// Upload data to database
		Firestore.firestore().collection("userPlaten").addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
				// TODO: call completionhandler
			} else {
				print("Document added with ID")
			}
		}
	}
	
	func deleteAlbum() {
//		self.db.collection("userPlaten").document(self.albums[indexPath.row].id).delete() { err in
//			if let err = err {
//				print(err)
//				print("Error removing document: \(err.localizedDescription)")
//				// TODO: UIAlertController
//			} else {
//				print("Document successfully removed!")
//				self.albums.remove(at: indexPath.row)
//				self.tableView.deleteRows(at: [indexPath], with: .automatic)
//			}
//		}
	}
	
	func createUser(username: String, email: String, password: String, successHandler: @escaping () -> (), failureHandler: @escaping (Error) -> ()) {
		Auth.auth().createUser(withEmail: email, password: password) { user, error in
			if let error = error {
				failureHandler(error)
				return
			}
			
			// Save user data to database
			let db = Firestore.firestore()
			db.collection("users").document(user!.user.uid).setData(["username": username, "email": email]) { err in
				// Error adding user to database
				if let err = err {
					print("Error adding document: \(err)")
				}
			}
			
			successHandler()
		}
	}
}
