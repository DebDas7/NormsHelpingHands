//
//  User.swift
//  NormsHelpingHands
//
//  Created by Deb Das on 2/18/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import Foundation

class User {
    var email : String = ""
    var uid : String = ""
    var id : String = ""
    
    init(email: String, uid: String, id: String) {
        self.email = email
        self.uid = uid
        self.id = id
    }
}
