//
//  ExploreViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/9/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ExploreViewController: UIViewController {

    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var aPostImage: UIImageView!
    @IBOutlet weak var bPostImage: UIImageView!
    @IBOutlet weak var cPostImage: UIImageView!
    @IBOutlet weak var dPostImage: UIImageView!
    
    var currentUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let mainTabBar = tabBarController as! MainTabBarController
        currentUser = mainTabBar.currentUser
        
    }
    
    func loadInPost() {
        let ref = Database.database().reference(withPath: "Posts")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var increment = 0;
            for child in snapshot.children {
                if increment == 4{
                    return
                }
                let snap = child as! DataSnapshot
                let placeDict = snap.value as! [String: Any]
                let eventKey = placeDict["eventKey"] as! String
                self.setPostImages(imgKey: eventKey, imgView: self.aPostImage)
                increment+=1
            }
        }
    }
    
    func setPostImages(imgKey: String, imgView: UIImageView) {
        let storage = Storage.storage()

        let storageRef = storage.reference()
        
        let reference = storageRef.child("eventImages/\(imgKey).jpg")
        
        let imageView: UIImageView = imgView

        let placeholderImage = UIImage(named: "placeHolderImage.jpg")

        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadInPost()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
