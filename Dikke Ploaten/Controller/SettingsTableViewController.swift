//
//  SettingsTableViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 21/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutUser(_ sender: Any) {
        // Sign out
        do {
            try Auth.auth().signOut()
        }
        catch {
            print ("Error signing out: %@", error)
        }
        
        // Go back to initial view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
}
