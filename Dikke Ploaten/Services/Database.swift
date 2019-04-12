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
	let auth = Auth.auth()
	let storageRef = Storage.storage().reference(forURL: "gs://dikke-ploaten.appspot.com")
	
	static let shared = Database()
	
	let userPlatenCollection = "platen"
	let userWantList = "wantList"
	
	private init(){}
	
	// Adds album to user's collection
	func addToCollection(album: Album, completionHandler: @escaping (Error?) -> ()) {
		addToUserPlatesList(albumId: album.id, name: userPlatenCollection, completionHandler: completionHandler)
	}
	
	// Adds album to user's wantlist
	func addToWantlist(album: Album, completionHandler: @escaping (Error?) -> ()) {
		addToUserPlatesList(albumId: album.id, name: userWantList, completionHandler: completionHandler)
	}
	
	private func addToUserPlatesList(albumId: String, name: String, completionHandler: @escaping (Error?) -> ()) {
		// Data from object in JSON
		let data = UserAlbum(albumID: albumId).toJSON()
		// Upload data to database
		db.collection("users").document(auth.currentUser!.uid).collection(name).addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
			} else {
				print("Album was succesfully added in collection!")
			}
			completionHandler(err)
		}
	}
	
	// Updates user's collection when album gets added/deleted
	func getUserPlates(completionHandler: @escaping ([Album]) -> ()) {
		getUserAlbumCollection(name: userPlatenCollection, completionHandler: completionHandler)
	}
	
	// Updates user's wantlist when album gets added/deleted
	func getUserWantlist(completionHandler: @escaping ([Album]) -> ()) {
		getUserAlbumCollection(name: userWantList, completionHandler: completionHandler)
	}
	
	private func getUserAlbumCollection(name: String, completionHandler: @escaping ([Album]) -> ()) {
		let userPlates = db.collection("users").document(auth.currentUser!.uid).collection(name)
		userPlates.getDocuments { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let userAlbums = snapshot.documents.map(UserAlbum.docToUserAlbum)
			var albums = [Album]()
			
			let group = DispatchGroup()
			
			for userAlbum in userAlbums {
				group.enter()
				self.db.collection("platen").document(userAlbum.albumID).getDocument { querySnapshot, error in
					guard let snapshot = querySnapshot else {
						print("Error fetching snapshots: \(error!)")
						group.leave()
						return
					}
					albums.append(Album.docToAlbum(document: snapshot))
					group.leave()
				}
			}
			
			group.notify(queue: .main) {
				completionHandler(albums)
			}
		}
	}
	
	// Gets the whole list of albums out of database
	func getAlbumList(completionHandler: @escaping (_ updatedCollection: [Album]) -> ()){
		db.collection("platen").getDocuments { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents: \(err)")
				return
			}
			let albums = querySnapshot!.documents.map(Album.docToAlbum)
			completionHandler(albums)
		}
	}
	
	// Deletes selected album out of collection
	func deleteCollectionAlbum(albumId: String, completionHandler: @escaping (Error?) -> ()) {
		deleteUserAlbum(name: userPlatenCollection, albumId: albumId, completionHandler: completionHandler)
	}
	
	// Deletes selected album out of wantlist
	func deleteWantlistAlbum(albumId: String, completionHandler: @escaping (Error?) -> ()) {
		deleteUserAlbum(name: userWantList, albumId: albumId, completionHandler: completionHandler)
	}
	
	private func deleteUserAlbum(name: String, albumId: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("users").document(auth.currentUser!.uid).collection(name)
			.whereField("albumID", isEqualTo: albumId)
			.getDocuments { snapshot, err in
				guard let snapshot = snapshot else {
					print("Error removing document: \(err?.localizedDescription ?? "")")
					completionHandler(err)
					return
				}
				
				self.db.collection("users").document(self.auth.currentUser!.uid).collection(name).document(snapshot.documents.first!.documentID).delete { err in
					completionHandler(err)
				}
		}
	}
}

// MARK: - User

extension Database {
	
	func createUser(username: String, email: String, password: String, successHandler: @escaping () -> (), failureHandler: @escaping (Error) -> ()) {
		auth.createUser(withEmail: email, password: password) { user, error in
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
	
	func getUser(completionHandler: @escaping (_ user: User) -> ()) {
		db.collection("users").document(auth.currentUser!.uid).getDocument { (docSnapshot , error) in
			guard let snapshot = docSnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let user = User.docToUser(document: snapshot)
			completionHandler(user)
		}
	}
	
	func getProfileImage(completionHandler: @escaping (_ data: Data) -> ()) {
		let profileRef = storageRef.child("images/profile/\(auth.currentUser!.uid).jpg")
		profileRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
			if let error = error {
				print("Error fetching data profileimage: \(error)")
				return
			}
			completionHandler(data!)
		}
	}
	
	func getProfileCover(completionHandler: @escaping (_ data: Data) -> ()) {
		let coverRef = storageRef.child("images/cover/\(auth.currentUser!.uid).jpg")
		coverRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
			if let error = error {
				print("Error fetching data profilecover: \(error)")
				return
			}
			completionHandler(data!)
		}
	}
	
	func updateUsername(username: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("users").document(auth.currentUser!.uid).updateData((["username": username])) { err in
			if let err = err {
				print("Error when changing username: \(err)")
			} else {
				print("Username was succesfully updated!")
			}
			completionHandler(err)
		}
	}
	
	func updatePassword(newPassword: String, completionHandler: @escaping (Error?) -> ()) {
		auth.currentUser?.updatePassword(to: newPassword) { err in
			if let err = err {
				print("Error when changing password: \(err)")
			} else {
				print("Password was succesfully updated!")
			}
			completionHandler(err)
		}
	}
	
	func isUserLoggedIn() -> Bool {
		return auth.currentUser != nil
	}
	
	// Upload image
	func uploadImage(image: UIImage, asProfileImage: Bool) {
		// Create imagePath
		let itemId = auth.currentUser!.uid
		var imagePath = ""
		if(asProfileImage){
			imagePath = "images/profile/\(itemId).jpg"
		} else {
			imagePath = "images/cover/\(itemId).jpg"
		}
		var data = NSData()
		data = image.jpegData(compressionQuality: 0.8)! as NSData
		let childImages = storageRef.child(imagePath)
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"
		// Upload
		childImages.putData(data as Data, metadata: metaData)
	}
}
