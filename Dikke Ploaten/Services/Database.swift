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
	func addToDatabase(album: Album/*, completionHandler: @escaping () -> ()*/) {
		// Data from object in JSON
		let data = album.toJSON()
		// Upload data to database
		Firestore.firestore().collection("userPlaten").addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
				//completionHandler()
			} else {
				print("Document added with ID")
			}
		}
	}
	
	func updateCollection(albums: [Album], completionHandler: @escaping (_ updatedCollection: [Album]) -> ()) {
		var albums = albums
		db.collection("userPlaten").limit(to: 1000).addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			for diff in snapshot.documentChanges {
				if (diff.type == .added) {
					let album = try! Mapper<Album>().map(JSON: diff.document.data())
					album.id = diff.document.documentID
					if album.userID == Auth.auth().currentUser?.uid {
						albums.append(album)
					}
				}
				if (diff.type == .removed) {
					let album = try! Mapper<Album>().map(JSON: diff.document.data())
					album.id = diff.document.documentID
					if let index = albums.firstIndex(of: album) {
						albums.remove(at: index)
					}
				}
			}
			completionHandler(albums)
		}
	}
	
	func getAlbumList(albums: [Album], completionHandler: @escaping (_ updatedCollection: [Album]) -> ()){
		var albumList = albums
		db.collection("platen").getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				for document in querySnapshot!.documents {
					print("\(document.documentID) => \(document.data())")
					let album = try! Mapper<Album>().map(JSON: document.data())
					album.id = document.documentID
					albumList.append(album)
				}
				completionHandler(albumList)
			}
		}
	}
	
	func deleteAlbum(albumId: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("userPlaten").document(albumId).delete() { err in
			if let err = err {
				print(err)
				print("Error removing document: \(err.localizedDescription)")
				completionHandler(err)
				// TODO: UIAlertController
			} else {
				print("Document successfully removed!")
			}
		}
		
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
	
	func checkUser() -> Bool {
		if Auth.auth().currentUser == nil {
			return false
		}
		return true
	}
}
