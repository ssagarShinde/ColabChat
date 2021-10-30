//
//  chatHistoryView.swift
//  ChatLib
//
//  Created by Apple on 04/08/21.
//

import UIKit

protocol chatHistoryDelegate: AnyObject {
    
}

class chatHistoryView: UIView {
    
    @IBOutlet weak var tblView: UITableView!
    
    var delegate : chatHistoryDelegate?
    var data = [[String:Any]]()
}
