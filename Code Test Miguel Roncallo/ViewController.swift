//
//  ViewController.swift
//  Code Test Miguel Roncallo
//
//  Created by Miguel Roncallo on 9/25/17.
//  Copyright © 2017 Miguel Roncallo. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contacts = ContactAPI.shared.contacts
    var filtered = [Contact]()
    var searchActive = false
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ContactAPI.shared.loadContacts()
        contacts = ContactAPI.shared.contacts
        ContactAPI.shared.deletionDelegate = self
        tableView.reloadData()
    }
    
    //MARK: - Internal helpers
    
    func setupTableview(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: ContactListTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
    }
    
    //MARK: - IBActions

    @IBAction func addContact(_ sender: UIBarButtonItem) {
        let addContactVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactViewController
        
        self.navigationController?.pushViewController(addContactVC, animated: true)
    }
    

    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(contacts.count)
        if searchActive{
            return filtered.count
        }
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.cellIdentifier, for: indexPath) as! ContactListTableViewCell
        
        if searchActive{
            cell.contactNameLabel.text = "\(filtered[indexPath.row].name!) \(filtered[indexPath.row].lastName!)"
            cell.contactNumberLabel.text = filtered[indexPath.row].phoneNumbers[0].stringValue
            cell.contactEmailLabel.text = filtered[indexPath.row].emails[0].stringValue
            cell.contactImageView.kf.setImage(with: URL(fileURLWithPath: filtered[indexPath.row].image), placeholder: UIImage(named: "userPlaceholder"))
            
            return cell
        }
        cell.contactNameLabel.text = "\(contacts[indexPath.row].name!) \(contacts[indexPath.row].lastName!)"
        cell.contactNumberLabel.text = contacts[indexPath.row].phoneNumbers[0].stringValue
        cell.contactEmailLabel.text = contacts[indexPath.row].emails[0].stringValue
        cell.contactImageView.kf.setImage(with: URL(fileURLWithPath: contacts[indexPath.row].image), placeholder: UIImage(named: "userPlaceholder"))
        print(contacts[indexPath.row].image)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailVC") as! ContactDetailViewController
        detailVC.contact = contacts[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let contact = contacts[indexPath.row]
            contacts.removeAll()
            ContactAPI.shared.deleteContact(contact: contact)
        }
    }
}

extension ViewController: ContactDeletionDelegate{
    func didDeleteContact() {
        contacts = ContactAPI.shared.contacts
        self.tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = contacts.filter({ (text) -> Bool in
            let tmp = text
            let range1 = tmp.name.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            let range2 = tmp.lastName.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            return (range1 != nil || range2 != nil)
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
