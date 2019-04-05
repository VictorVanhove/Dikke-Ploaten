//
//  ProfileViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {
	
	// MARK: - Properties
	var collectionAlbums: [Album] = []
	var wantlistAlbums: [Album] = []
	
	@IBOutlet weak var imgBackgroundCover: UIImageView!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var lblUser: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.estimatedRowHeight = self.tableView.rowHeight
		self.tableView.rowHeight = UITableView.automaticDimension
		
		Database.shared.getUser { user in
			self.lblUser.text = user.username
		}
		
		Database.shared.getUserPlates { (albums) in
			self.collectionAlbums = albums
			self.tableView.reloadData()
		}
		
		Database.shared.getUserWantlist { (albums) in
			self.wantlistAlbums = albums
			self.tableView.reloadData()
		}
		
		imgProfile.layer.borderWidth = 1
		imgProfile.layer.masksToBounds = false
		imgProfile.layer.borderColor = UIColor.black.cgColor
		imgProfile.layer.cornerRadius = imgProfile.frame.height/2
		imgProfile.clipsToBounds = true
		
	}
	
	struct Storyboard {
		static let collectionCell = "collectionCell"
		static let wantlistCell = "wantlistCell"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.collectionCell, for: indexPath) as! CollectionHolderTableViewCell
		
		return cell
		
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
	{
		if let cell = cell as? CollectionHolderTableViewCell {
			cell.collectionCollectionView.dataSource = self
			cell.collectionCollectionView.delegate = self
			cell.collectionCollectionView.reloadData()
			cell.collectionCollectionView.isScrollEnabled = false
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt
		indexPath: IndexPath) -> CGFloat
	{
		return tableView.bounds.width + 68.0
	}
	
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionAlbums.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.collectionCell, for: indexPath) as! AlbumCollectionViewCell
		
		if(!collectionAlbums.isEmpty){
			cell.image = UIImage(data: try! Data(contentsOf: URL(string: collectionAlbums[indexPath.item].cover)!))
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let layout = collectionViewLayout as! UICollectionViewFlowLayout
		layout.minimumLineSpacing = 5.0
		layout.minimumInteritemSpacing = 1.0
		
		let numberOfItemsPerRow: CGFloat = 2.0
		let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsPerRow
		
		return CGSize(width: itemWidth, height: itemWidth)
	}
	
}
