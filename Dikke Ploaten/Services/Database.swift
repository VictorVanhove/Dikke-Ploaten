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
	
	let cache = Cache()
	
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
		let userAlbum = UserAlbum(albumID: albumId)
		let data = userAlbum.toJSON()
		// Upload data to database
		db.collection("users").document(auth.currentUser!.uid).collection(name).addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
			} else {
				print("Album was succesfully added in collection!")
				switch name {
				case self.userPlatenCollection:
					self.cache.user.plates.append(userAlbum)
				case self.userWantList:
					self.cache.user.wantList.append(userAlbum)
				default:
					break
				}
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
			
			switch name {
			case self.userPlatenCollection:
				self.cache.user.plates = userAlbums
			case self.userWantList:
				self.cache.user.wantList = userAlbums
			default:
				break
			}
			
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
			
			self.cache.albums = albums
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
					if err == nil {
						switch name {
						case self.userPlatenCollection:
							self.cache.user.plates.remove(at: self.cache.user.plates.firstIndex { $0.albumID == albumId }!)
						case self.userWantList:
							self.cache.user.wantList.remove(at: self.cache.user.wantList.firstIndex { $0.albumID == albumId }!)
						default:
							break
						}
					}
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
				self.cache.user = User(username: username, email: email, plates: [], wantList: [])
				successHandler()
			}
		}
	}
	
	func getUser(completionHandler: @escaping (_ user: User) -> ()) {
		db.collection("users").document(auth.currentUser!.uid).getDocument { (docSnapshot , error) in
			guard let snapshot = docSnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let user = User.docToUser(document: snapshot)
			self.cache.user = user
			completionHandler(user)
		}
	}
	
	func getProfileImage(completionHandler: @escaping (_ data: Data?) -> ()) {
		let profileRef = storageRef.child("images/profile/\(auth.currentUser!.uid).jpg")
		profileRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
			completionHandler(data)
		}
	}
	
	func getProfileCover(completionHandler: @escaping (_ data: Data?) -> ()) {
		let coverRef = storageRef.child("images/cover/\(auth.currentUser!.uid).jpg")
		coverRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
			completionHandler(data)
		}
	}
	
	func updateUsername(username: String, completionHandler: @escaping (Error?) -> ()) {
		db.collection("users").document(auth.currentUser!.uid).updateData((["username": username])) { err in
			if let err = err {
				print("Error when changing username: \(err)")
			} else {
				print("Username was succesfully updated!")
			}
			self.cache.user.username = username
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
