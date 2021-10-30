//
//  EndChatView.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 19/04/21.
//

import UIKit

protocol EndChatDelegate: AnyObject {
    
    func didCancelButtonTapped()
    func didEndChatButtonTapped()
    func didAgentEndChatButtonTapped()
    func closeAgentView()
}

class EndChatView: UIView {
    var delegate : EndChatDelegate?
    var delegate2 : EndChatDelegate?
    
    @IBOutlet weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.isHidden = true
        }
    }
    
    @IBOutlet weak var btnEndChat: CurveBtn!
    @IBOutlet weak var btnCancel: CurveBtn!
    
    
    
    @IBOutlet weak var agentEndChatView: UIView!
    @IBAction func CancelBtnAction(_ sender: Any) {
        if delegate != nil {
             delegate!.didCancelButtonTapped()
         }
    }
    
    @IBAction func EndChatBtnAction(_ sender: Any) {
        if delegate != nil {
             delegate!.didEndChatButtonTapped()
         }
    }
    
    @IBAction func closeWindowBtn(_ sender: Any) {
        if delegate != nil {
            delegate!.didAgentEndChatButtonTapped()
        }
        
        if delegate2 != nil {
            delegate2!.closeAgentView()
        }
    }
}
