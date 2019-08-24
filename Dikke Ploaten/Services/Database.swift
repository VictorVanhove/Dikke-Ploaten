//
//  Database.swift
//  Dikke Ploaten
//
//  Created by Wim Van Renterghem on 26/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper
import Alamofire

class Database {
	
	//Firebase
	let database = Firestore.firestore()
	let auth = Auth.auth()
	let storageRef = Storage.storage().reference(forURL: "gs://dikke-ploaten.appspot.com")
	
	static let shared = Database()
	
	let userPlatenCollection = "platen"
	let userWantList = "wantList"
	
	let cache = Cache()
	
	private init() {}
	
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
		database.collection("users").document(auth.currentUser!.uid).collection(name).addDocument(data: data) { err in
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
		let userPlates = database.collection("users").document(auth.currentUser!.uid).collection(name)
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
				self.database.collection("platen").document(userAlbum.albumID).getDocument { querySnapshot, error in
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
	func getAlbumList(completionHandler: @escaping (_ updatedCollection: [Album]) -> ()) {
		database.collection("platen").getDocuments { querySnapshot, err in
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
		database.collection("users").document(auth.currentUser!.uid).collection(name)
			.whereField("albumID", isEqualTo: albumId)
			.getDocuments { snapshot, err in
				guard let snapshot = snapshot else {
					print("Error removing document: \(err?.localizedDescription ?? "")")
					completionHandler(err)
					return
				}
				
				self.database.collection("users").document(self.auth.currentUser!.uid).collection(name).document(snapshot.documents.first!.documentID).delete { err in
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
			self.database.collection("users").document(user!.user.uid).setData(["username": username, "email": email]) { err in
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
		database.collection("users").document(auth.currentUser!.uid).getDocument { docSnapshot, error in
			guard let snapshot = docSnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			let user = User.docToUser(document: snapshot)
			self.cache.user.username = user.username
			self.cache.user.email = user.email
			completionHandler(user)
		}
	}
	
	func getProfileImage(completionHandler: @escaping (_ data: Data?) -> ()) {
		let profileRef = storageRef.child("images/profile/\(auth.currentUser!.uid).jpg")
		profileRef.getData(maxSize: 15 * 1024 * 1024) { data, _ in
			completionHandler(data)
		}
	}
	
	func getProfileCover(completionHandler: @escaping (_ data: Data?) -> ()) {
		let coverRef = storageRef.child("images/cover/\(auth.currentUser!.uid).jpg")
		coverRef.getData(maxSize: 15 * 1024 * 1024) { data, _ in
			completionHandler(data)
		}
	}
	
	func updateUsername(username: String, completionHandler: @escaping (Error?) -> ()) {
		database.collection("users").document(auth.currentUser!.uid).updateData((["username": username])) { err in
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
		if asProfileImage {
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

// MARK: - Discogs API

extension Database {
	
	func importDiscogsDocumentsToFirebase(completionHandler: @escaping (_ documentID: String) -> ()) {
		// Change id for importing jsons
		for id in 21...40 {
			let urlString = "https://api.discogs.com/artists/\(id)/releases?secret=ayNFZAMFUUonMcbKYfiTFFrzZLJTIzYi&page=1&key=haPLcXIqXkohtMRIhgsx"
			getJsonDataFromUrl(stringUrl: urlString, completionHandler: { data in
				self.addDiscogsDocumentToFirebase(data: data, completionHandler: { documentID in
					print("Document was succesfully added!")
					completionHandler(documentID)
				})
			})
		}
	}
	
	//this function is fetching the json from URL
	private func getJsonDataFromUrl(stringUrl: String, completionHandler: @escaping ([String: Any]) -> ()) {
		URLSession.shared.dataTask(with: URL(string: stringUrl)!) { data, _, _ in
			if let data = data {
				if let jsonString = String(data: data, encoding: .utf8) {
					completionHandler(jsonString.toJSON()!)
				}
			}
			}.resume()
	}
	
	private func addDiscogsDocumentToFirebase(data: [String: Any], completionHandler: @escaping (_ documentID: String) -> ()) {
		var ref: DocumentReference? = nil
		ref = self.database.collection("discogsDocuments").addDocument(data: data) { err in
			if let err = err {
				print("Error adding document: \(err)")
			}
			completionHandler(ref!.documentID)
		}
	}
	
	func importDiscogsAlbumsFromDocumentToFirebase(documentID: String) {
		self.database.collection("discogsDocuments").document(documentID).getDocument { documentSnapshot, err in
			guard let snapshot = documentSnapshot else {
				print("Error fetching snapshots: \(err!)")
				return
			}
			let albumArray = DiscogsDocument.docToDiscogsDocument(document: snapshot)
			
			for album in albumArray.releases ?? [] {
				print(album.title)
				self.database.collection("platenDiscogs").addDocument(data: album.toJSON())
			}
			print("VOLGEND DOCUMENT")
		}
	}
	
}
