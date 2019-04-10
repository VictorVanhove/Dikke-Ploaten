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
				print("Document was succesfully added!")
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
			// Filters albums or else it will show all the albums instead of just the user
			var filteredAlbums = [Album]()
			for album in albums {
				if(album.userID == Auth.auth().currentUser!.uid){
					filteredAlbums.append(album)
				}
			}
			completionHandler(filteredAlbums)
		}
	}
	
	// Updates user's wantlist when album gets added/deleted
	func getUserWantlist(completionHandler: @escaping (_ updatedCollection: [Album]) -> ()) {
		db.collection("userWantlist").limit(to: 1000).getDocuments { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let albums = snapshot.documents.map(Album.docToAlbum)
			// Filters albums or else it will show all the albums instead of just the user
			var filteredAlbums = [Album]()
			for album in albums {
				if(album.userID == Auth.auth().currentUser!.uid){
					filteredAlbums.append(album)
				}
			}
			completionHandler(filteredAlbums)
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
	func deleteCollectionAlbum(albumId: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("userPlaten").document(albumId).delete() { err in
			if let err = err {
				print("Error removing document: \(err.localizedDescription)")
			} else {
				print("Document with id:\(albumId) successfully removed!")
			}
			completionHandler(err)
		}
		
	}
	
	// Deletes selected album out of wantlist
	func deleteWantlistAlbum(albumId: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("userWantlist").document(albumId).delete() { err in
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
			self.db.collection("users").document(user!.user.uid).setData(["username": username, "email": email, "password": password]) { err in
				// Error adding user to database
				if let err = err {
					print("Error adding document: \(err)")
				}
			}
			
			successHandler()
		}
	}
	
	func getUser(completionHandler: @escaping (_ user: User) -> ()) {
		let user = Auth.auth().currentUser
		db.collection("users").document(user!.uid).getDocument { (docSnapshot , error) in
			guard let snapshot = docSnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let user = User.docToUser(document: snapshot)
			completionHandler(user)
		}
	}
	
	func updateUsername(username: String, completionHandler: @escaping (Error?) -> ()) {
		let user = Auth.auth().currentUser
		db.collection("users").document(user!.uid).updateData((["username": username])) { err in
			if let err = err {
				print("Error when changing username: \(err)")
			} else {
				print("Username was succesfully updated!")
			}
			completionHandler(err)
		}
	}
	
	func updatePassword(newPassword: String, completionHandler: @escaping (Error?) -> ()) {
		let user = Auth.auth().currentUser
		Auth.auth().currentUser?.updatePassword(to: newPassword) { err in
			if let err = err {
				print("Error when changing password: \(err)")
			} else {
				print("Password was succesfully updated!")
			}
			completionHandler(err)
		}
		
		db.collection("users").document(user!.uid).updateData((["password": newPassword]))
	}
	
	func isUserLoggedIn() -> Bool {
		return Auth.auth().currentUser != nil
	}
}
