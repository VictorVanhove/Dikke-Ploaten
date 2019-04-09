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
}

extension CollectionHolderTableViewCell : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 12
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCollectionViewCell
		return cell
	}
	
}

extension CollectionHolderTableViewCell : UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let itemsPerRow:CGFloat = 4
		let hardCodedPadding:CGFloat = 5
		let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
		let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
		return CGSize(width: itemWidth, height: itemHeight)
	}
	
}
