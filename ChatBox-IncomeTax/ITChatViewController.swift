//
//  ViewController.swift
//  ChatBox-IncomeTax
//
//  Created by Raja Vikram on 09/02/17.
//  Copyright © 2017 ZeMoSo Technologoes Pvt. Ltd. All rights reserved.
//

import UIKit
import AI
import RxSwift
import RxCocoa

class ITChatViewController: UIViewController {
    
    var chats : Variable<[ChatMessage]> = Variable([])
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var postMessageView: UIView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendMessage: UIButton!
    @IBOutlet weak var voiceRecord: UIButton!
    @IBOutlet weak var postMessageViewBottomConstaint: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    var lastChatText = "To Calculate Tax simply reply \" tax \""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.chatTableView.estimatedRowHeight = 300
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        createInitialChatMessage()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
         let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.chatTableView.addGestureRecognizer(tap)
        
        messageField.rx_text.map({!$0.isEmpty}).bindTo(sendMessage.rx_enabled).addDisposableTo(disposeBag)
        
        self.chats.asObservable().subscribeNext { (chats) in
            self.chatTableView.reloadData()
        }.addDisposableTo(disposeBag)
        
        sendMessage.rx_tap.subscribeNext { _ in
            let outputMessage = ChatMessage(message: self.messageField.text!)
            outputMessage.deliveryStatus.asObservable().subscribeNext({ (_) in
                self.chatTableView.reloadData()
            }).addDisposableTo(self.disposeBag)
            self.chats.value.append(outputMessage)
            let indexPath = NSIndexPath(forRow: self.chats.value.count-1, inSection: 0)
            self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            AI.sharedService.TextRequest(self.messageField.text!).success({ response in
                if !(response.result.metadata.intentName == CBConstants.defaultFallbackIntent || response.result.metadata.intentName == CBConstants.defaultWelcomeIntent) {
                    self.lastChatText = ""
                }
                if let fullfilment = response.result.fulfillment {
                    outputMessage.deliveryStatus.value = .Delivered
                    var message:String = fullfilment.speech
                    if !self.lastChatText.isEmpty {
                        message = message + "\n" + self.lastChatText
                    }else {
                         self.lastChatText = fullfilment.speech
                    }
                    self.createResponseMessage(message)
                }
            }).failure({ error in
                print(error)
                if error.code == 206 && error.localizedDescription == "partial content" {
                    outputMessage.deliveryStatus.value = .Delivered
                    self.createResponseMessage(self.lastChatText)
                }
                else {
                    outputMessage.deliveryStatus.value = .Falied
                }
            })
            self.messageField.text = ""
            self.messageField.rx_text// = ""
        }.addDisposableTo(disposeBag)
        
        voiceRecord.rx_tap.subscribeNext { (_) in
            self.voiceRecord.enabled = false
            AI.sharedService.VoiceRequest(true).success({ response in
                let outputMessage = ChatMessage(message: response.result.source, deliveryStatus: .Delivered)
                outputMessage.deliveryStatus.asObservable().subscribeNext({ (_) in
                    self.chatTableView.reloadData()
                }).addDisposableTo(self.disposeBag)
                self.chats.value.append(outputMessage)
                if let response = response.result.fulfillment {
                    let responseMessage = ChatMessage(message: response.speech, deliveryStatus: .Received)
                    self.chats.value.append(responseMessage)
                }
                let indexPath = NSIndexPath(forRow: self.chats.value.count-1, inSection: 0)
                self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            }).failure({ error in
                print(error)
            }).resume({ (response) in
                self.voiceRecord.enabled = true
            })
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createInitialChatMessage() {
        let initialChat = ChatMessage(message: "Hi, I am an IT Bot. If you want to calculate income tax for FY 2016-17 then simply reply \"tax\"", deliveryStatus: .Received)
        self.chats.value = [initialChat]
    }
    
    func createResponseMessage(message:String) {
        let responseMessage = ChatMessage(message: message, deliveryStatus: .Received)
        self.chats.value.append(responseMessage)
        let indexPath = NSIndexPath(forRow: self.chats.value.count-1, inSection: 0)
        self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    // MARK:- Keyboard Functions
    func keyboardWillShow(notification: NSNotification) {
       animatePostMessageView(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animatePostMessageView(notification)
    }
    
    func animatePostMessageView(keyboardNotification: NSNotification) {
        if let usrInfo = keyboardNotification.userInfo {
            let frame = (usrInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let finalValue:CGFloat
            if frame.origin.y != UIScreen.mainScreen().bounds.height {
                finalValue = frame.height
            }
            else {
                finalValue = 0
            }
            
            let movementDuration:NSTimeInterval = usrInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            let animationCurve = usrInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
            UIView.animateWithDuration(movementDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: animationCurve >> 16) , animations: { () -> Void in
                self.postMessageViewBottomConstaint.constant = finalValue
                self.view.layoutIfNeeded()
                }, completion:nil)
        }
    }
    
    func dismissKeyboard() {
        self.messageField.resignFirstResponder()
    }
    

}

extension ITChatViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chat = chats.value[indexPath.row]
        switch chat.deliveryStatus.value {
        case .Delivered,.Falied, .Sending:
            let cell = tableView.dequeueReusableCellWithIdentifier("outgoing", forIndexPath: indexPath) as! OutgoingTableViewCell
            cell.outgoingMessage.text = chat.message
            cell.deliveryStatus.text = chat.deliveryStatus.value.rawValue
            switch chat.deliveryStatus.value {
            case .Falied:
                cell.deliveryStatus.textColor = UIColor.redColor()
            case .Delivered:
                cell.deliveryStatus.textColor = UIColor.greenColor()
            default:
                cell.deliveryStatus.textColor = UIColor.blackColor()
            }
            return cell
        case .Received:
            let cell = tableView.dequeueReusableCellWithIdentifier("incoming", forIndexPath: indexPath) as! InComingTableViewCell
            cell.incomingMessage.text = chat.message
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
}

