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
    @IBOutlet weak var eventButton: UIButton!
    var currentUser : UserModel!
    var isOwner : Bool = false
    var isJoined : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTabBar = tabBarController as! MainTabBarController
        currentUser = mainTabBar.currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfJoined(postKey: postKey)
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
            
            var creatorID = snapshot.childSnapshot(forPath: "\(postKey)/eventCreatorUID").value! as! String
            if (creatorID == self.currentUser.uid) {
                self.isOwner = true;
                self.eventButton.setTitle("Delete!", for: UIControl.State.normal)
            }
            print(creatorID)
            print()
            print(self.isOwner)
            self.postDescLabel.sizeToFit()
            // self.postCapcityLabel.text = snapshot.childSnapshot(forPath: "\(postKey)/").value! as! String
        })
    }
    
    func checkIfJoined(postKey: String) {
        let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }

            // data found
            let myData = snapshot.value as! [String: Bool]

            for (key, value) in myData {
                if(postKey == key) {
                    self.isJoined = true
                    self.eventButton.setTitle("Leave!", for: UIControl.State.normal)
                }
            }
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
        var alert = UIAlertController(title: "Volunteer Event", message: "Your event was successfully posted!", preferredStyle: .alert)
        
        if (isOwner) {
            let ref = Database.database().reference(withPath: "Posts")
            ref.child(postKey).removeValue()
            
            alert.message = "You successfully deleted the event!"
        } else if (!isJoined) {
            let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
            ref.updateChildValues([postKey : true])
            
            alert.message = "You successfully joined the event!"
            
        } else {
            let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
            ref.child(postKey).removeValue()
            
            alert.message = "You left the event!"
            
        }
        
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }

}
/*
 if (!isJoined) {
     let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
     ref.updateChildValues([postKey : true])
     
     alert.message = "You successfully joined the event!"
     
 } else {
     let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
     ref.child(postKey).removeValue()
     
     alert.message = "You left the event!"
     
 }
 */
