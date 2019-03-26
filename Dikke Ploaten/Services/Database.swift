//
//  Database.swift
//  Dikke Ploaten
//
//  Created by Wim Van Renterghem on 26/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper

class Database {
	
    let db = Firestore.firestore()
    
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
    
    func updateCollection(albums: [Album], completionHandler: (_ updatedCollection: [Album]) -> ()) {
        db.collection("userPlaten").limit(to: 1000).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            for diff in snapshot.documentChanges {
                if (diff.type == .added) {
                    let album = try! Mapper<Album>().map(JSON: diff.document.data())
                    album.id = diff.document.documentID
                    self.albums.append(album)
                }
                if (diff.type == .removed) {
                    let album = try! Mapper<Album>().map(JSON: diff.document.data())
                    album.id = diff.document.documentID
                    if let index = self.albums.firstIndex(of: album) {
                        self.albums.remove(at: index)
                    }
                }
            }
            completionHandler(this.albums = albums)
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
