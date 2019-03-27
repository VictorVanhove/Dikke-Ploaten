//
//  SecondViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 13/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class WantlistViewController: UITableViewController {
	
	// MARK: - Properties
	var albums: [Album] = []
	// Firebase
	let db = Firestore.firestore()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Gets data from database and updates on changes
		//        db.collection("platen").limit(to: 1000).addSnapshotListener { querySnapshot, error in
		//            guard let snapshot = querySnapshot else {
		//                print("Error fetching snapshots: \(error!)")
		//                return
		//            }
		//            snapshot.documents.forEach({ diff in
		//            })
		//                self.tableView.reloadData()
		//            }
		//        db.collection("platen").getDocuments() { (querySnapshot, err) in
		//            if let err = err {
		//                print("Error getting documents: \(err)")
		//            } else {
		//                for document in querySnapshot!.documents {
		//                    print("\(document.documentID) => \(document.data())")
		//                }
		//            }
		//        }
	}
	
	
}

