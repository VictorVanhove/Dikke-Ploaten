//
//  UserAlbum.swift
//  Dikke Ploaten
//
//  Created by Wim Van Renterghem on 12/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper

class UserAlbum: ImmutableMappable, Equatable {
	var id: String = ""
	var albumID: String
	
	init(albumID: String) {
		self.albumID = albumID
	}
	
	// MARK: - ObjectMapper
	required init(map: Map) throws {
		albumID = try map.value("albumID")
	}
	
	func mapping(map: Map) {
		albumID		>>> map["albumID"]
	}
	
	static func docToUserAlbum(document: QueryDocumentSnapshot) -> UserAlbum {
		let userAlbum = try! Mapper<UserAlbum>().map(JSON: document.data())
		userAlbum.id = document.documentID
		return userAlbum
	}
	
	static func == (lhs: UserAlbum, rhs: UserAlbum) -> Bool {
		return lhs.id == rhs.id
	}
}
