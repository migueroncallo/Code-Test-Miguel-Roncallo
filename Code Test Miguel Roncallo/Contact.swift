//
//  Contact.swift
//  Code Test Miguel Roncallo
//
//  Created by Miguel Roncallo on 9/25/17.
//  Copyright © 2017 Miguel Roncallo. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object{
    
    dynamic var name: String!
    dynamic var lastName: String!
    dynamic var image: String!
    var phoneNumbers = List<RealmString>()
    var emails = List<RealmString>()
    var addresses = List<RealmString>()
    dynamic var facebook: String!
    dynamic var twitter: String!
    dynamic var snapchat: String!
    dynamic var instagram: String!
    dynamic var dateOfBirth: String!
    
    convenience init(name: String, lastName: String, image: String = "", phoneNumber: String, email: String, dateOfBirth: String, address: String = "", facebook: String = "", twitter: String = "", instagram: String = "", snapchat: String = "") {
        self.init()
        self.name = name
        self.lastName = lastName
        self.image = image
        self.phoneNumbers.append(RealmString().object(from: phoneNumber))
        self.emails.append(RealmString().object(from: email))
        self.addresses.append(RealmString().object(from: address))
        self.facebook = facebook
        self.twitter = twitter
        self.instagram = instagram
        self.snapchat = snapchat
        self.dateOfBirth = dateOfBirth
        
    }
    
}

class RealmString: Object {
    dynamic var stringValue = ""
    
    func object(from: String) -> RealmString{
        let rlmString = RealmString()
        
        rlmString.stringValue = from
        
        return rlmString
    }
}
