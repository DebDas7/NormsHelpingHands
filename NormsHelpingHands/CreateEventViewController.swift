//
//  CreateEventViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/10/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase

class CreateEventViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var createEvent: UIButton!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dateSelector: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: nil, action: nil)

        self.imageView.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(recognizer:)))
        singleTap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(singleTap)
        // Do any additional setup after loading the view.
    }
    
    @objc func singleTap(recognizer: UIGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After its complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        } else {
            // Error msg
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createEventTapped(_ sender: Any) {
        
        let event = [
            "eventCreator": "", // the users name
            "eventCreatorUID": "", // the uid of the user
            "title": titleText.text!,
            "date": "\(dateSelector.date)",
            "description": descriptionText.text!
        ]
        
        let ref = Database.database().reference(fromURL: "https://norms-helping-hands.firebaseio.com/")
        let postReference = ref.child("Posts")
        let id = postReference.childByAutoId().key
        postReference.child(id!).setValue(event) { (err, ref) in
            if err != nil {
                print(err.self as Any)
                return
            }
        }
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
