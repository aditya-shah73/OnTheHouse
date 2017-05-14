//
//  MessagingViewController.swift
//  OnTheHouse
//
//  Created by Michael Hyun on 5/13/17.
//  Copyright © 2017 CMPE137. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MessageLogViewController: UITableViewController {

    
    var messages: [Message]?
    var cellId = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        observeMessages()
    }
    
    func observeMessages(){
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject]{
                let message = Message()
                message.text = dictionary["text"] as? String
                message.fromID = dictionary["fromID"] as? String
                message.timestamp = dictionary["timestamp"] as? String
                message.toID = dictionary["toID"] as? String
                print(message.text ?? "")
                self.messages?.append(message)
                
                self.tableView.reloadData()
            }
            
        })
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages?[indexPath.row]
        cell.message = message!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    

}
