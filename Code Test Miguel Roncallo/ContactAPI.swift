//
//  ContactAPI.swift
//  Code Test Miguel Roncallo
//
//  Created by Miguel Roncallo on 9/25/17.
//  Copyright © 2017 Miguel Roncallo. All rights reserved.
//

import Foundation
import RealmSwift

class ContactAPI{
    
    static let shared = ContactAPI()
    
    var contacts = [Contact]()
    
    let realm = try! Realm()
    
    var delegate: ContactCreationDelegate!
    var deletionDelegate: ContactDeletionDelegate!
    
    func addContact(name: String, lastName: String, email: String, image: String = "", phoneNumber: String, address: String = "", twitter: String = "", facebook: String = "", instagram: String = "", snapchat: String = "", dateOfBirth: String){
        
        let contact = Contact.init(name: name, lastName: lastName,  image: image, phoneNumber: phoneNumber, email: email, dateOfBirth: dateOfBirth, address: address, facebook: facebook, twitter: twitter, instagram: instagram, snapchat: snapchat)
        
        try! realm.write {
            realm.add(contact)
        }
        
        contacts.append(contact)
        delegate.didCreateUser()
    }
    
    func editContact(name: String, lastName: String, email: String, image: String = "", phoneNumber: String, address: String = "", twitter: String = "", facebook: String = "", instagram: String = "", snapchat: String = "", dateOfBirth: String, contact: Contact){
        
        try! realm.write {
            contact.name = name
            contact.lastName = lastName
            contact.emails.first!.stringValue = email
            contact.image = image
            contact.phoneNumbers.first!.stringValue = phoneNumber
            contact.addresses.first!.stringValue = address
            contact.twitter = twitter
            contact.facebook = facebook
            contact.instagram = instagram
            contact.snapchat = snapchat
            contact.dateOfBirth = dateOfBirth
        }
        delegate.didFinishEditingUser(contact: contact)
    }
    
    func deleteContact(contact: Contact){
        try! realm.write {
            realm.delete(contact)
        }
        loadContacts()
        deletionDelegate.didDeleteContact()
    }
    
    func loadContacts(){
        contacts = Array(realm.objects(Contact.self).sorted(byKeyPath: "name"))
    }
}

protocol ContactCreationDelegate: class{
    func didCreateUser()
    func didFinishEditingUser(contact: Contact)
}

protocol ContactDeletionDelegate: class{
    func didDeleteContact()
}
