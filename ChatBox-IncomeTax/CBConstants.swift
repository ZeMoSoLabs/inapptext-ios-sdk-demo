//
//  CBConstants.swift
//  InAppText SDK Demo
//
//  Created by Raja Vikram on 09/02/17.
//  Copyright © 2017 ZeMoSo Technologoes Pvt. Ltd. All rights reserved.
//

import UIKit

internal let CB_CLIENT_ACCESS_TOKEN = "f6f661dee8a7461ebc70a3372115416e"

class CBConstants: NSObject {
    
    static let appColor = UIColor.colorFromCode(0x1E9E5E)
    
    static let redColor = UIColor.colorFromCode(0xFF001F)
    
    static let whiteColor = UIColor.whiteColor()
    
    static let smallTalkPlaceholder = "Now where were we."
    
    static let placeHolderMessage = "Now where were we.\nTo calculate tax simply reply \"tax\"."
}

class APIConstants: NSObject {
    static let defaultWelcomeIntent = "Default Welcome Intent"
    static let defaultFallbackIntent = "Default Fallback Intent"
    static let defaultDialogueIntent = "what_to_enter"
    static let domains = "domains"
    static let smallTalkAction = "smalltalk"
}

extension UIColor {
    class func colorFromCode(code: Int , alpha : CGFloat = 1) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
