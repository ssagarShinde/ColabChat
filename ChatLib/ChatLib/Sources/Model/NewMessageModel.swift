//
//  NewMessageModel.swift
//  ChatLib
//
//  Created by Sagar on 23/09/21.
//

import Foundation


class NewMessageModel: Codable {
    var data: DataClass?
    let eventName: String?
    let from : String?
    
    init(data: DataClass?, eventName: String?, from : String?) {
        self.data = data
        self.eventName = eventName
        self.from = from
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case from = "From"
        case eventName
    }
}
