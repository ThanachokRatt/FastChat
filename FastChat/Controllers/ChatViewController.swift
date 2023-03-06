//
//  ChatViewController.swift
//  FastChat
//
//  Created by Schweppe on 5/3/2566 BE.
//


import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController{
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    //อ่าน messageจาก sendPressed
    func loadMessages() {
        
        // .order คำสั่งorder by เรียงลำดับเวลาการส่งmessageก่อนที่จะโหลดข้อความขึ้นหน้าจอ(addSnapshotListener)
        // addSnapshotListener โหลดข้อความแบบreal time และแสดงขึ้นหน้าจอ
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
            self.messages = []
            if let e = error {
                print("There was an isse retrieving data from Firestore. \(e)")
            }else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let  messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMeaasge = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMeaasge)
                            
                            
                            //self.tableView.reloadData แสดง message , user ที่หน้าจอ
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                //ฟังชั้นทำให้หน้าchatแสดงข้อความล่าสุดที่userส่งมา (scrollToRow)
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender,K.FStore.bodyField: messageBody,K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error{
                    print("There was an issue saving data to firestore, \(e)")
                }else{
                    print("Successfully saved data.")
                    //ทำให้ ข้อความในtextfieldหายไปหลังuserกดส่งข้อความ
                    self.messageTextfield.text = ""
                }
            }
            
            
        }
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
       
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,for: indexPath) as! MessageCell
        
        cell.label.text = message.body
        
        //ข้อความจากcurrent user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            
            
        }
        // ข้อความจาก another sender
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            
        }
        
        return cell
    }
    
    
}

