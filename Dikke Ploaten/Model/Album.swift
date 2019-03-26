//
//  Album.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import Firebase
import ObjectMapper

class Album : ImmutableMappable, Hashable, Comparable {
    var id: String = ""
    var title: String
    var artist: String
    var cover: String
    var genre: String?
    var releaseYear: Int?
    let userID: String?
    // Firebase
    let db = Firestore.firestore()
    // Hashable
    var hashValue: Int {
        return id.hashValue
    }
    
    // MARK: - Constructors
    init(title: String, artist: String, cover: String, genre: String?, releaseYear: Int?) {
        self.title = title
        self.artist = artist
        self.cover = cover
        self.userID = Auth.auth().currentUser!.uid
        self.genre = genre
        self.releaseYear = releaseYear
    }
    
    // MARK - ObjectMapper
    required init(map: Map) throws {
        title = try map.value("titel")
        artist = try map.value("uitvoerder")
        cover = try map.value("image")
        userID = try? map.value("user")
        genre = try? map.value("genre")
        releaseYear = try? map.value("releaseYear")
    }
    
    func mapping(map: Map) {
        title       >>> map["titel"]
        artist      >>> map["uitvoerder"]
        cover       >>> map["image"]
        userID      >>> map["user"]
        genre       >>> map["genre"]
        releaseYear >>> map["releaseYear"]
    }
    
    func setId(id: String) {
        self.id = id
    }
    
    func toDatabase(){
        // Data from object in JSON
        let data = self.toJSON()
        // Upload data to database
        db.collection("userPlaten").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID")
            }
        }
    }
    
    // Equatable
    static func == (lhs: Album  , rhs: Album) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Comparable
    static func < (lhs: Album, rhs: Album) -> Bool {
        return lhs.artist < rhs.artist
    }
    
    
    
}
