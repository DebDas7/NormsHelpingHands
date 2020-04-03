//
//  SignInViewController.swift
//  NormsHelpingHands
//
//  Created by Deb Das on 2/11/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    var currentUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func QUICKSIGNIN(_ sender: Any) {
        self.emailTextField.text = "gname@uncc.edu"
        self.passwordTextField.text = "123456"
        signinTapped("TESTING ONLY")
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        
        // Validate text fields
        let formatErr = validateFields()
        
        if formatErr != nil {
            
            //there is something wrong /w fields
            showError(formatErr!)
            
        } else {
        
            // Creat cleaned verison of the text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    // Could not sign in
                    self.showError("Incorrect credentials or Account does not exist")
                    
                    print("Unsuccessful sign in")
                } else {
                    print("Successful sign in")
                    
                    var ref = Database.database().reference()
                    let uid = Auth.auth().currentUser?.uid
                    var firstName = ""
                    var lastName = ""
                    var email = ""
                    var key = ""
                    
//                    ref.child("Users").queryOrdered(byChild: "uid").queryEqual(toValue: uid!).observe(.value) { (querySnapshot) in
//                        
//                        if !querySnapshot.exists() { return }
//                        
//                        for result in querySnapshot.children {
//                            let resultSnapshot = result as! DataSnapshot
//                            key = resultSnapshot.key
//                        }
//                    }
                    
                    ref.child("Users").queryOrdered(byChild: "uid").queryEqual(toValue: uid!).observeSingleEvent(of: .value, with: { querySnapshot in

                        if !querySnapshot.exists() { return }
                        
                        for result in querySnapshot.children {
                            let resultSnapshot = result as! DataSnapshot
                            key = resultSnapshot.key
                        }
                    })
                    
                    ref = Database.database().reference(withPath: "Users")
                    ref.observeSingleEvent(of: .value, with: { snapshot in

                        if !snapshot.exists() { return }

                        email = snapshot.childSnapshot(forPath: "\(key)/email").value! as! String
                        firstName = snapshot.childSnapshot(forPath: "\(key)/firstName").value! as! String
                        lastName = snapshot.childSnapshot(forPath: "\(key)/lastName").value! as! String
                        
                        self.currentUser = UserModel(firstName: firstName, lastName: lastName, email: email, uid: uid!, key: key)
                        self.performSegue(withIdentifier: "signInToTab", sender: self)
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabController = segue.destination as? MainTabBarController {
            tabController.currentUser = self.currentUser! as UserModel
        }
    }
    
    func validateFields() -> String? {
        //email regex, checking for @uncc.edu (insesntive)
        let emailRegEx = "[A-Z0-9a-z.-_]+@(?i)(uncc)+\\.(edu)(?-i)"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let validEmail = emailPred.evaluate(with: emailTextField.text!)
        
        //checking for empty field, etc.
        if  emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            !validEmail {
            
            return "Please use UNCC email and check for empty fields"
        }
        
        if passwordTextField.text!.count < 6  {
            return "Your password must be 6 characters long"
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
        self.errorLabel.sizeToFit()
    }

}
