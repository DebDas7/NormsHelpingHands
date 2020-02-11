//
//  LoginViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 2/9/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        navigateToMainInterface()
    }
    
    private func navigateToMainInterface() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainNavigationVC = mainStoryBoard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
    }
}
