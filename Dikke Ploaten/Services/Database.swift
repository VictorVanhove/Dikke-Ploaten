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
	
	//Firebase
	let db = Firestore.firestore()
	
	static let shared = Database()
	
	private init(){}
	
	// Adds album to user's collection
	func addToCollection(album: Album, completionHandler: @escaping (Error?) -> ()) {
		// Data from object in JSON
		let data = album.toJSON()
		// Upload data to database
		Firestore.firestore().collection("userPlaten").addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
			} else {
				print("Document added with ID")
			}
			completionHandler(err)
		}
	}
	
	// Adds album to user's wantlist
	func addToWantlist(album: Album, completionHandler: @escaping (Error?) -> ()) {
		// Data from object in JSON
		let data = album.toJSON()
		// Upload data to database
		Firestore.firestore().collection("userWantlist").addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
			} else {
				print("Document added with ID")
			}
			completionHandler(err)
		}
	}
	
	// Updates user's collection when album gets added/deleted
	func getUserPlates(completionHandler: @escaping (_ updatedCollection: [Album]) -> ()) {
		db.collection("userPlaten").limit(to: 1000).getDocuments { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let albums = snapshot.documents.map(Album.docToAlbum)
			completionHandler(albums)
		}
	}
	
	// Updates user's wantlist when album gets added/deleted
	func getUserWantlist(completionHandler: @escaping (_ updatedCollection: [Album]) -> ()) {		db.collection("userWantlist").limit(to: 1000).getDocuments { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let albums = snapshot.documents.map(Album.docToAlbum)
			completionHandler(albums)
		}
	}
	
	// Gets the whole list of albums out of database
	func getAlbumList(completionHandler: @escaping (_ updatedCollection: [Album]) -> ()){
		db.collection("platen").getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
			} else {
				let albums = querySnapshot!.documents.map(Album.docToAlbum)
				completionHandler(albums)
			}
		}
	}
	
	// Deletes selected album out of collection
	func deleteAlbum(albumId: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("userPlaten").document(albumId).delete() { err in
			if let err = err {
				print("Error removing document: \(err.localizedDescription)")
			} else {
				print("Document with id:\(albumId) successfully removed!")
			}
			completionHandler(err)
		}
		
	}
	
	func createUser(username: String, email: String, password: String, successHandler: @escaping () -> (), failureHandler: @escaping (Error) -> ()) {
		Auth.auth().createUser(withEmail: email, password: password) { user, error in
			if let error = error {
				failureHandler(error)
				return
			}
			self.db.collection("users").document(user!.user.uid).setData(["username": username, "email": email]) { err in
				// Error adding user to database
				if let err = err {
					print("Error adding document: \(err)")
				}
			}
			
			successHandler()
		}
	}
	
	func isUserLoggedIn() -> Bool {
		return Auth.auth().currentUser != nil
	}
}
