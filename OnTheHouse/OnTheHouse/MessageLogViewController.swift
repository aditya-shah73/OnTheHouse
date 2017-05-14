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

    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()

    var cellId = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    
    func observeMessages(){
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.fromID = dictionary["fromID"] as? String
                message.toID = dictionary["toID"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                self.messages.append(message)
                print(message.text!)
                print(self.messages)
                
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                if let toId = message.toID {
                    self.messagesDictionary[toId] = message
                    
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        
                        return (message1.timestamp?.int32Value)! > (message2.timestamp?.int32Value)!
                    })
                }
            }
            
        }, withCancel: nil)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    

}
