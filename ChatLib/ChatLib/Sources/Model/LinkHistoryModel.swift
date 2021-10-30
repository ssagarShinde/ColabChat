//
//  LinkHistoryModel.swift
//  ChatLib
//
//  Created by Sagar on 07/10/21.
//

import Foundation

class LinkHistory {
    static let shared = LinkHistory()
    var obj = [History]()
}



class LinkHistoryModel: Codable {
    let data: Datass?
    let eventName: String?

    init(data: Datass?, eventName: String?) {
        self.data = data
        self.eventName = eventName
    }
}

class Datass: Codable {
    let result : String?
    let draw, recordsTotal: Int?
    let datas: [History]?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case draw, recordsTotal
        case datas = "data"
    }
    
    init(result: String?, draw: Int?, recordsTotal: Int?, datas : [History]?) {
        self.result = result
        self.draw = draw
        self.recordsTotal = recordsTotal
        self.datas = datas
    }
}

class History: Codable {
    let assignedToAgent, assignedToTeam, caseSource, createdDate: String?
    let emailCC, fullName, lastIxnBy, lastIxnDate: String?
    let primaryEmail, primaryPhone, requestedBy, requestorRemark: String?
    let status, subject, uCreatedDate, uLastIxnDate: String?
    let caseid: String?

    enum CodingKeys: String, CodingKey {
        case assignedToAgent = "AssignedToAgent"
        case assignedToTeam = "AssignedToTeam"
        case caseSource = "CaseSource"
        case createdDate = "CreatedDate"
        case emailCC = "EmailCC"
        case fullName = "FullName"
        case lastIxnBy = "LastIxnBy"
        case lastIxnDate = "LastIxnDate"
        case primaryEmail = "PrimaryEmail"
        case primaryPhone = "PrimaryPhone"
        case requestedBy = "RequestedBy"
        case requestorRemark = "RequestorRemark"
        case status = "Status"
        case subject = "Subject"
        case uCreatedDate = "UCreatedDate"
        case uLastIxnDate = "ULastIxnDate"
        case caseid
    }

    init(assignedToAgent: String?, assignedToTeam: String?, caseSource: String?, createdDate: String?, emailCC: String?, fullName: String?, lastIxnBy: String?, lastIxnDate: String?, primaryEmail: String?, primaryPhone: String?, requestedBy: String?, requestorRemark: String?, status: String?, subject: String?, uCreatedDate: String?, uLastIxnDate: String?, caseid: String?) {
        self.assignedToAgent = assignedToAgent
        self.assignedToTeam = assignedToTeam
        self.caseSource = caseSource
        self.createdDate = createdDate
        self.emailCC = emailCC
        self.fullName = fullName
        self.lastIxnBy = lastIxnBy
        self.lastIxnDate = lastIxnDate
        self.primaryEmail = primaryEmail
        self.primaryPhone = primaryPhone
        self.requestedBy = requestedBy
        self.requestorRemark = requestorRemark
        self.status = status
        self.subject = subject
        self.uCreatedDate = uCreatedDate
        self.uLastIxnDate = uLastIxnDate
        self.caseid = caseid
    }
}

