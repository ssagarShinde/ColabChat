//
//  AgentModel.swift
//  ChatLib
//
//  Created by Sagar on 16/08/21.
//

import Foundation

class AgentModel {
    static let shared = AgentModel()
    
    var agentId = ""
    var agentName = ""
    var joinMessage = ""
    
    func saveData(agentId : String, agentName : String, joinMessage : String) {
        
        self.agentId = agentId
        self.agentName = agentName
        self.joinMessage = joinMessage
    }
    
    func clearData() {
        agentId = ""
        agentName = ""
        joinMessage = ""
    }
}
