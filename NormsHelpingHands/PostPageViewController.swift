//
//  PostPageViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/18/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostPageViewController: UIViewController {

    var postKey : String = ""
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postDescLabel: UILabel!
    @IBOutlet weak var postCapcityLabel: UILabel!
    var currentUser : UserModel!
    var isOwner : Bool = false
    var isJoined : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTabBar = tabBarController as! MainTabBarController
        currentUser = mainTabBar.currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setPostImages(imgKey: postKey)
        setPostInfo(postKey: postKey)
    }
    
    func setPostInfo(postKey: String) {
        let ref = Database.database().reference(withPath: "Posts")
        ref.observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            self.postTitleLabel.text = snapshot.childSnapshot(forPath: "\(postKey)/title").value! as! String
            self.postTitleLabel.sizeToFit()
            self.postDateLabel.text = snapshot.childSnapshot(forPath: "\(postKey)/date").value! as! String
            self.postDateLabel.sizeToFit()
            self.postDescLabel.text = snapshot.childSnapshot(forPath: "\(postKey)/description").value! as! String
            self.postDescLabel.sizeToFit()
            // self.postCapcityLabel.text = snapshot.childSnapshot(forPath: "\(postKey)/").value! as! String
        })
    }
    
    func setPostImages(imgKey: String) {
        let storage = Storage.storage()

        let storageRef = storage.reference()
        
        let reference = storageRef.child("eventImages/\(imgKey).jpg")
        
        let imageView: UIImageView = postImageView

        let placeholderImage = UIImage(named: "placeHolderImage.jpg")

        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }

    @IBAction func joinClicked(_ sender: Any) {
        let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
        ref.updateChildValues([postKey : true])
        
    }

}
