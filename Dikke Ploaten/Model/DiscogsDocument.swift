//
//  DiscogsAlbum.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 24/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper

class DiscogsDocument: ImmutableMappable, Hashable, Comparable {
	var id: String = ""
	var releases: [Album]?
	
	// MARK: - Constructors
	init(releases: [Album]?) {
		self.releases = releases
	}
	
	// MARK: - ObjectMapper
	required init(map: Map) throws {
		releases = try? map.value("releases")
	}
	
	func mapping(map: Map) {
		releases       >>> map["releases"]
	}
	
	// Hashable
	var hashValue: Int {
		return id.hashValue
	}
	
	static func < (lhs: DiscogsDocument, rhs: DiscogsDocument) -> Bool {
		return lhs.id < lhs.id
	}
	
	static func == (lhs: DiscogsDocument, rhs: DiscogsDocument) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func docToDiscogsDocument(document: DocumentSnapshot) -> DiscogsDocument {
		let albumDocument = try! Mapper<DiscogsDocument>().map(JSON: document.data()!)
		albumDocument.id = document.documentID
		return albumDocument
	}
}
