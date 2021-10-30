//
//  MessageVM.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import UIKit

final class MessageVM {
    
    static let shared = MessageVM()
    var messageArray = [[String: Any]]()
    
    var isHoverShowing : Bool = true
    var hover = HoverView()
    var btnScreenshare : Bool = true
    var btnVideo : Bool = true
}

final class SeenModel {
    static let shared = SeenModel()
    var arrSeen = [Seen]()
}

class Seen {
    var msgID : String
    var value : Bool
    
    init(msgIDs: String, values: Bool) {
        self.msgID = msgIDs
        self.value = values
    }
}
