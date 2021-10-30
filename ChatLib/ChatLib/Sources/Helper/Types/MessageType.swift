//
//  MessageType.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 15/05/21.
//

enum Message: String {
    
    // MARK:-  System
    case System = "SYSTEM"
   
    // MARK:-  User
    case User = "User"
    
    // MARK:-  Agent
    case Agent = "AGENT"
}

enum MessageType: String {
    
    // MARK:-  Text
    case Text = "TEXT"
    
    //MARK:- Event Online
    case Online = "EventOnline"
}

enum FileType: String {
    
    // MARK:-  Image
    case Image = "TEXT"
    
    //MARK:- Event Online
    case Online = "EventOnline"
}

