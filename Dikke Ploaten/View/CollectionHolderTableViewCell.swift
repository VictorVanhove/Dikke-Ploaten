//
//  CollectionHolderTableViewCell.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 04/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit

class CollectionHolderTableViewCell: UITableViewCell {
	@IBOutlet weak var collectionCollectionView: UICollectionView!
	
	var albums: [Album] = []
	
	func updateAlbums(albums: [Album]){
		self.albums = []
		self.albums = albums
		collectionCollectionView.reloadData()
	}
}

extension CollectionHolderTableViewCell : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if albums.isEmpty {
			return 0
		}
		return albums.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCollectionViewCell
		
		if(!albums.isEmpty){
			cell.updateUI(forAlbum: albums[indexPath.item])
		}
		return cell
	}
	
}

extension CollectionHolderTableViewCell: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow:CGFloat = 4
		let hardCodedPadding:CGFloat = 5
		let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
		return CGSize(width: itemWidth, height: itemWidth)
	}
	
}
