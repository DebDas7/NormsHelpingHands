//
//  UserModel.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/12/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import Foundation

class UserModel {
    var email : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var uid : String = ""
    var key : String = ""

    init(firstName: String, lastName: String, email: String, uid: String, key: String) {
        self.firstName =  firstName
        self.lastName = lastName
        self.email = email
        self.uid = uid
        self.key = key
    }
}
