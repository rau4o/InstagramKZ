//
//  FeedVC.swift
//  InstagramKz
//
//  Created by rau4o on 8/11/19.
//  Copyright © 2019 rau4o. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationController?.navigationItem.leftBarButtonItem = btn
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //configure logout button
        collectionView.backgroundColor = .black
        
        configureLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.leftBar
        ButtonItem = UIBarButtonItem(image: UIImage(named: "not appear"), style: .plain, target: self, action: #selector(handleMessage))
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    //MARK: - Handles
    func configureLogoutButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "not appear"), style: .plain, target: self, action: #selector(handleMessage))
    }
    
    @objc func handleMessage() {
        print("dasd")
    }
    
    @objc func handleLogout() {
        
        //declare alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //add action controller
        alertController.addAction(UIAlertAction(title: "logout", style: .destructive, handler: { (_) in
            do {
                //attempt sign out
                try Auth.auth().signOut()
                
                //present login controller
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
                
            }catch {
                //handle error
                print("Failed to sign out")
            }
        }))
        //add cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
