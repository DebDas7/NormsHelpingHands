//
//  SignUpViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 2/11/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func validateFields() -> String? {
        //email regex, checking for @uncc.edu (insesntive)
        let emailRegEx = "[A-Z0-9a-z.-_]+@(?i)(uncc)+\\.(edu)(?-i)"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let vaildEmail = emailPred.evaluate(with: emailField.text!)
        
        //checking for empty field, etc.
        if firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            !vaildEmail {
            
            return "Please use UNCC email and check for empty fields"
        }
        
        if passwordField.text != confirmPasswordField.text {
            return "Passwords do not match"
        }
        
        return nil
    }
    
    @IBAction func onCreateAccountClicked(_ sender: UIButton) {
        //validate fields
        let error = validateFields()
        
        if error != nil {
            
            //there is something wrong /w fields
            showError(error!)
            
        } else {
            
            //create the account
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in

                let ref = Database.database().reference(fromURL: "https://norms-helping-hands.firebaseio.com/")
                let usersReference = ref.child("Users")
                let id = usersReference.childByAutoId().key

                InstanceID.instanceID().instanceID(handler: { (result, error) in
                    let values = ["email": self.emailField.text!,
                                  "password": self.passwordField.text!,
                                  "firstName": self.firstNameField.text!,
                                  "lastName":self.lastNameField.text!,
                                  "eventsAttedned": "0"]
                    usersReference.child(id!).setValue(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err.self as Any)
                            return
                        }
                        print("Successfully saved user in Firebase DB")

                    })

                })

            }
            //transition to home screen
            self.transitionToHome()
            
        }
        
    }
    
    func showError(_ message:String) {
        errorField.text = message
        errorField.alpha = 1
        errorField.sizeToFit()
    }
    
    func transitionToHome() {
    
        let tabViewController = storyboard?.instantiateViewController(identifier: "TabVC")
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
