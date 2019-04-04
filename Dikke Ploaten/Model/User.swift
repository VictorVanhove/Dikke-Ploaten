//
//  User.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 04/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper

class User: ImmutableMappable, Hashable, Comparable {
	var id: String = ""
	var username: String
	
	// MARK: - Constructors
	init(username: String) {
		self.username = username
	}
	
	// MARK - ObjectMapper
	required init(map: Map) throws {
		username = try map.value("username")
	}
	
	func mapping(map: Map) {
		username	>>> map["username"]
	}
	
	// Hashable
	var hashValue: Int {
		return id.hashValue
	}
	
	// Equatable
	static func < (lhs: User, rhs: User) -> Bool {
		return lhs.id == rhs.id
	}
	
	// Comparable
	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.username < rhs.username
	}
	
	static func docToUser(document: DocumentSnapshot) -> User {
		let user = try! Mapper<User>().map(JSON: document.data()!)
		user.id = document.documentID
		return user
	}
	
}
