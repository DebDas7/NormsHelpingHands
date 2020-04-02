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

    private let dataSource = [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75]
    var currentUser: UserModel!
    
    @IBOutlet weak var createEvent: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dateSelector: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var attendNumberPickerView: UIPickerView!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTabBar = tabBarController as! MainTabBarController
        currentUser = mainTabBar.currentUser
                
        // connect data
        attendNumberPickerView.delegate = self
        attendNumberPickerView.dataSource = self
        
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
        
        let ref = Database.database().reference(fromURL: "https://norms-helping-hands.firebaseio.com/")
        let postReference = ref.child("Posts")
        let id = postReference.childByAutoId().key
        
        print(dateSelector.date)
        let event = [
            "eventCreator": "\(currentUser.firstName) \(currentUser.lastName)", // the users name
            "eventCreatorUID": currentUser.uid, // the uid of the user
            "eventKey": id!,
            "title": titleText.text!,
            "date": "\(dateSelector.date)",
            "description": descriptionText.text!
        ]
        
        postReference.child(id!).setValue(event) { (err, ref) in
            if err != nil {
                print(err.self as Any)
                return
            }
        }
        
        let uploadRef = Storage.storage().reference(withPath: "eventImages/\(id!).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetaData, error) in
            if let error = error {
                print("error upload event pic: \(error)")
                return
            }
            print("put is complete")
        }
        
        print("post successfully added")
        
        //push back into explore with popup
        let alert = UIAlertController(title: "Volunteer Event", message: "Your event was successfully posted!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: true)
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

extension CreateEventViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataSource[row])
    }
    
}
