//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Sai Reddy on 13/08/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        // Do any additional setup after loading the view.
        loadMessages()
    }
    
    func loadMessages(){
        messages = []
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener {
            QuerySnapshot, error in
            
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }
            else{
                if let snapshotDocuments = QuerySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessages = Messages(sender: sender, body: messageBody)
                            self.messages.append(newMessages)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print("There was an issue saving data to firebase \(e)")
                }
                else{
                    print("Successfully saved")
                }
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
}
