//
//  Messaging.swift
//  ChatLib
//
//  Created by Sagar on 22/09/21.
//

import Foundation

class Messaging {
    static let shared = Messaging()
    var obj = [Messages]()
    var lastSeen = [String]()
}


class MessagingModel: Codable {
    var data: DataClass?
    let eventName: String?
    let from : String?
    
    init(data: DataClass?, eventName: String?, from : String?) {
        self.data = data
        self.eventName = eventName
        self.from = from
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "ChatID"
        case from = "From"
        case eventName
    }
}

class DataClass: Codable {
    var chatHistory: [Messages]?
    let chatInteractionID: String?
   // let previousChat: Int?

    enum CodingKeys: String, CodingKey {
        case chatHistory
        case chatInteractionID = "chatInteractionId"
      //  case previousChat
    }
    
    init(chatHistory: [Messages]?, chatInteractionID: String?, previousChat: Int?) {
        self.chatHistory = chatHistory
        self.chatInteractionID = chatInteractionID
       // self.previousChat = previousChat
    }
}

class Messages: Codable {
    let dateTime, filePath, fileType, message: String?
    let messageID, messageType, type, event: String?
    let agentData: AgentData?
   // let status: Bool?
    var showMore = 4

    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
        case filePath = "FilePath"
        case fileType = "FileType"
        case message = "Message"
        case messageID = "MessageId"
        case messageType = "MessageType"
        case type = "Type"
        case agentData
        case event = "Event"
    }

    init(dateTime: String?, filePath: String?, fileType: String?, message: String?, messageID: String?, messageType: String?, type: String?, agentData: AgentData?, event : String?) {
        self.dateTime = dateTime
        self.filePath = filePath
        self.fileType = fileType
        self.message = message
        self.messageID = messageID
        self.messageType = messageType
        self.type = type
        self.agentData = agentData
        self.event = event
       // self.status = status
    }
}

class LastSeen {
    var msgId = ""
    var value = false
}

class AgentData: Codable {
    let agentLoginID, agentProfilePic, agentRole, name: String?

    enum CodingKeys: String, CodingKey {
        case agentLoginID = "agentLoginId"
        case agentProfilePic, agentRole, name
    }
    
    init(agentLoginID: String?, agentProfilePic: String?, agentRole: String?, name: String?) {
        self.agentLoginID = agentLoginID
        self.agentProfilePic = agentProfilePic
        self.agentRole = agentRole
        self.name = name
    }
}

