//
//  ProfileViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/12/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileImage()
        
        // make the profile pic round
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        self.profileImageView.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(recognizer:)))
        singleTap.numberOfTouchesRequired = 1
        profileImageView.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view.
    }
    
    func setProfileImage() {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Reference to an image file in Firebase Storage
        let reference = storageRef.child("profilePicture/tst.jpg") // change

        // UIImageView in your ViewController
        let imageView: UIImageView = self.profileImageView

        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.jpg")

        // Load the image using SDWebImage
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
    @objc func singleTap(recognizer: UIGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        } else {
            // Error msg
        }
        self.dismiss(animated: true, completion: nil)
        updateProfilePicture()
    }
    
    func updateProfilePicture() {
        let uploadRef = Storage.storage().reference(withPath: "profilePicture/tst.jpg")
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetaData, error) in
            if let error = error {
                print("error upload profile pic")
                return
            }
            print("put is complete")
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
        
        self.performSegue(withIdentifier: "logOutToSignIn", sender: self)
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
