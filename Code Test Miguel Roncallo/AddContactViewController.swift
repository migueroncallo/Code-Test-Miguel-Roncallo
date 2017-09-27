//
//  AddContactViewController.swift
//  Code Test Miguel Roncallo
//
//  Created by Miguel Roncallo on 9/25/17.
//  Copyright © 2017 Miguel Roncallo. All rights reserved.
//

import UIKit
import Kingfisher

enum ContactAction{
    case add
    case edit
}

class AddContactViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextfield: UITextField!
    
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var facebookTextField: UITextField!
    
    @IBOutlet weak var instagramTextField: UITextField!
    
    @IBOutlet weak var snapchatTextField: UITextField!
    
    @IBOutlet weak var twitterTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var imagePath = ""
    var delegate: AddContactDelegate!
    
    var action = ContactAction.add
    var contact: Contact!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContactAPI.shared.delegate = self
        imagePicker.delegate = self
        setupNavigationBar()
        setupDatePicker()
        
        if action == .edit{
            setupContactInfo()
        }
    }
    
    
    //MARK: - Internal Helpers
    
    func setupNavigationBar(){
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveUser(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationController?.title = "Add Contact"
    }
    
    func validateData() -> Bool{
        if nameTextField.text!.isEmpty || lastNameTextfield.text!.isEmpty || dateOfBirthTextField.text!.isEmpty || emailTextField.text!.isEmpty || phoneNumberTextField.text!.isEmpty{
            return false
        }
        return true
    }
    
    func setupDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func setupContactInfo(){
        contactImageView.kf.setImage(with: URL(fileURLWithPath: contact.image), placeholder: UIImage(named: "userPlaceholder"))
        
        nameTextField.text = contact.name!
        lastNameTextfield.text = contact.lastName!
        phoneNumberTextField.text = contact.phoneNumbers.first!.stringValue
        
        emailTextField.text = contact.emails.first!.stringValue
        addressTextField.text = contact.addresses.first!.stringValue
        dateOfBirthTextField.text = contact.dateOfBirth
        
        facebookTextField.text = contact.facebook
        twitterTextField.text = contact.twitter
        instagramTextField.text = contact.instagram
        snapchatTextField.text = contact.snapchat
    }
    
    func saveUser(_ sender: UIBarButtonItem){
        if validateData(){
            var address = ""
            var twitter = ""
            var facebook = ""
            var instagram = ""
            var snapchat = ""
            
            if let a = addressTextField.text{
                address = a
            }
            
            if let t = twitterTextField.text{
                twitter = t
            }
            
            if let f = facebookTextField.text{
                facebook = f
            }
            
            if let i = instagramTextField.text{
                instagram = i
            }
            
            if let s = snapchatTextField.text{
                snapchat = s
            }
            
            
            switch action{
            case .add:
                ContactAPI.shared.addContact(name: nameTextField.text!, lastName: lastNameTextfield.text!, email: emailTextField.text!, image: imagePath, phoneNumber: phoneNumberTextField.text!, address: address, twitter: twitter, facebook: facebook, instagram: instagram, snapchat: snapchat, dateOfBirth: dateOfBirthTextField.text!)
            case .edit:
                ContactAPI.shared.editContact(name: nameTextField.text!, lastName: lastNameTextfield.text!, email: emailTextField.text!, image: imagePath, phoneNumber: phoneNumberTextField.text!, address: address, twitter: twitter, facebook: facebook, instagram: instagram, snapchat: snapchat, dateOfBirth: dateOfBirthTextField.text!, contact: contact)
                
            }
            
            self.dismiss(animated: true, completion: nil)
        }else{
            print("All info is required")
        }
    }
    
    //MARK: - IBActions
    @IBAction func changeUserPhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - ContactCreationDelegate protocol conformance

extension AddContactViewController: ContactCreationDelegate{
    func didCreateUser() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didFinishEditingUser(contact: Contact){
        delegate.didEditUser(contact: contact)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddContactViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        contactImageView.image = image
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as? NSURL
        let imageName         = imageUrl?.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.appendingPathComponent(imageName!)
        
        imagePath = localPath!.path
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

protocol AddContactDelegate: class{
    func didEditUser(contact: Contact)
}
