//
//  MainTabVC.swift
//  InstagramKz
//
//  Created by rau4o on 8/11/19.
//  Copyright © 2019 rau4o. All rights reserved.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        configureViewControllers()
        
        //user validation
        checkUserLoggedIn()
    }
    
    func configureViewControllers() {
        
        //1
        let feedVC = constructNavController(undSelectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //2
        let searchVC = constructNavController(undSelectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchVC())
        //3
        let uploadPostVC = constructNavController(undSelectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: UploadPostVC())
        //4
        let notificationVC = constructNavController(undSelectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationsVC())
        //5
        let userProfileVC = constructNavController(undSelectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //add to tabbarVC
        viewControllers = [feedVC,searchVC,uploadPostVC,notificationVC,userProfileVC]
        
        //tab bar tint color
        tabBar.barTintColor = .black
    }
    
    //constructc navigationControllers
    func constructNavController(undSelectedImage: UIImage,selectedImage: UIImage,rootViewController: UIViewController = UIViewController()) -> UINavigationController  {
        
        //construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = undSelectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        //return navController
        return navController
    }
    
    func checkUserLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated: true, completion: nil)
            }
        }
        return
    }

}
