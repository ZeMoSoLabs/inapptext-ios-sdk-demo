//
//  ChatMessage.swift
//  InAppText SDK Demo
//
//  Created by Raja Vikram on 13/02/17.
//  Copyright © 2017 ZeMoSo Technologoes Pvt. Ltd. All rights reserved.
//

import UIKit
import RxSwift

class ChatMessage: NSObject {

    var message: String
    var deliveryStatus:Variable<ChatDeliveryStatus> = Variable(.Sending)
    
    override private init() {
        message = ""
        super.init()
    }
    
    convenience init(message:String, deliveryStatus:ChatDeliveryStatus = .Sending) {
        self.init()
        self.message = message
        self.deliveryStatus.value = deliveryStatus
    }
}

enum ChatDeliveryStatus: String {
    case Sending = "Sending"
    case Falied = "Failed"
    case Delivered = "Delivered"
    case Received = "Received"
}
