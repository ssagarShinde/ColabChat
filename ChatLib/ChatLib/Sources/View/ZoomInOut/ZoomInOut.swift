//
//  ZoomInOut.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 08/05/21.
//

import UIKit

protocol ZoomInOutDelegate: AnyObject {
    
    func didIncreaseButtonTapped()
    func didDecreaseButtonTapped()
}

class ZoomInOut: UIView {
    
    @IBOutlet weak var ZoomPer: UILabel!
    var delegate : ZoomInOutDelegate?

    @IBAction func fontIncrease(_ sender: Any) {
        if delegate != nil {
             delegate!.didIncreaseButtonTapped()
         }
    }
    
    @IBAction func fontDecrease(_ sender: Any) {
        if delegate != nil {
             delegate!.didDecreaseButtonTapped()
         }
    }
}
