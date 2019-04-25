//
//  DiscogsAlbum.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 24/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper

//class DiscogsAlbum: ImmutableMappable, Hashable, Comparable {
//	var id: String = ""
//	var title: String
//	var artist: String
//
//	// MARK: - Constructors
//	init(title: String, artist: String, cover: String, images: [String], description: String, genre: String, releaseYear: String, tracklist: String, musicians: String) {
//		self.title = title
//		self.artist = artist
//	}
//
//	// MARK: - ObjectMapper
//	required init(map: Map) throws {
//		title = try map.value("title")
//		artist = try map.value("artist")
//	}
//
//	func mapping(map: Map) {
//		title       >>> map["title"]
//		artist      >>> map["artist"]
//	}
//
//	// Hashable
//	var hashValue: Int {
//		return id.hashValue
//	}
//
//	// Equatable
//	static func == (lhs: DiscogsAlbum, rhs: DiscogsAlbum) -> Bool {
//		return lhs.id == rhs.id
//	}
//
//	// Comparable
//	static func < (lhs: DiscogsAlbum, rhs: DiscogsAlbum) -> Bool {
//		return lhs.artist < rhs.artist
//	}
//
//	static func docToDiscogsAlbum(document: DocumentSnapshot) -> DiscogsAlbum {
//		let album = try! Mapper<DiscogsAlbum>().map(JSON: document.data()!)
//		album.id = document.documentID
//		return album
//	}
//}

class DiscogsDocument: ImmutableMappable, Hashable, Comparable {
	var id: String = ""
	var releases: [Album]
	
	// MARK: - Constructors
	init(releases: [Album]) {
		self.releases = releases
	}
	
	// MARK: - ObjectMapper
	required init(map: Map) throws {
		releases = try map.value("releases")
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
