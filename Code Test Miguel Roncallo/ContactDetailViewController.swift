//
//  ContactDetailViewController.swift
//  Code Test Miguel Roncallo
//
//  Created by Miguel Roncallo on 9/26/17.
//  Copyright © 2017 Miguel Roncallo. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI

class ContactDetailViewController: UIViewController{
    
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactPhoneLabel: UILabel!
    
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    @IBOutlet weak var contactBirthdayLabel: UILabel!
    
    @IBOutlet weak var facebookLabel: UILabel!
    
    @IBOutlet weak var snapchatLabel: UILabel!
    
    @IBOutlet weak var instagramLabel: UILabel!
    
    @IBOutlet weak var twitterLabel: UILabel!
    
    var contact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContactInfo()
        setupNavigationBar()
        
    }
    
    //MARK: - Internal Helpers
    
    func setContactInfo(){
        contactImageView.kf.setImage(with: URL(fileURLWithPath: contact.image), placeholder: UIImage(named: "userPlaceholder"))
        
        contactNameLabel.text = "\(contact.name!) \(contact.lastName!)"
        
        contactPhoneLabel.text = contact.phoneNumbers.first!.stringValue
        
        contactEmailLabel.text = contact.emails.first!.stringValue
        
        contactBirthdayLabel.text = contact.dateOfBirth
        
        facebookLabel.text = contact.facebook
        twitterLabel.text = contact.twitter
        instagramLabel.text = contact.instagram
        snapchatLabel.text = contact.snapchat
    }
    
    func setupNavigationBar(){
        self.navigationItem.title = "Detail"
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.edit(_:)))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func edit(_ sender: UIBarButtonItem){
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactViewController
        editVC.action = .edit
        editVC.contact = contact
        editVC.delegate = self
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    //MARK: - IBActions
    
    @IBAction func callContact(_ sender: UIButton) {
        
        if let url = URL(string: "tel://\(contact.phoneNumbers.first!.stringValue)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func emailContact(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail(){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([contact.emails.first!.stringValue])
            self.present(composeVC, animated: true, completion: nil)
            
        }else{
            print("Email unavailable")
        }
    }
    
    
}

extension ContactDetailViewController: MFMailComposeViewControllerDelegate{
   
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetailViewController: AddContactDelegate{
    func didEditUser(contact: Contact){
        self.contact = contact
        setContactInfo()
    }
}
