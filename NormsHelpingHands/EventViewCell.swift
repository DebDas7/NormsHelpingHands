//
//  EventViewCell.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/29/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase

class EventViewCell: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    func setEventInfo(eventKey: String) {
        let ref = Database.database().reference(withPath: "Posts")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            self.eventTitleLabel.text = snapshot.childSnapshot(forPath: "\(eventKey)/title").value! as! String
        })
        
        setPostImages(imgKey: eventKey, imgView: eventImageView)
    }
    
    func setPostImages(imgKey: String, imgView: UIImageView) {
        let storage = Storage.storage()

        let storageRef = storage.reference()
        
        let reference = storageRef.child("eventImages/\(imgKey).jpg")
        
        let imageView: UIImageView = imgView

        let placeholderImage = UIImage(named: "placeHolderImage.jpg")

        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
