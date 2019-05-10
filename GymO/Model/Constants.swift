//
//  Constants.swift
//  GymAlk
//
//  Created by Catherine on 7/29/18.
//  Copyright © 2018 GymAlk. All rights reserved.
//

//NOT USED
import Foundation
import UIKit

class Constants {
    
    //DBProvider
    static let CONTACTS = "Contacts"
    static let MESSAGES = "Messages"
    static let MEDIA_MESSAGES = "Media_Messages"
    static let IMAGE_STORAGE = "Image_Storage"
    static let VIDEO_STORAGE = "Video_Storage"
    
    static let EMAIL = "email"
    static let PASSWORD = "password"
    static let DATA = "data"
    
    //messages
    static let TEXT = "text"
    static let SENDER_ID = "sender_id"
    static let SENDER_NAME = "sender_name"
    static let URL = "url"
    
   
}

class ViewConstants {
    static func loginAndSignUpCornerRadius(viewHeight: CGFloat) -> CGFloat
    {
        
        return (viewHeight - viewHeight/5)/2
        
    }
    
    static func cornerRadiusForCircles(viewHeight: CGFloat) -> CGFloat {
        
        return viewHeight/2
    }
}
