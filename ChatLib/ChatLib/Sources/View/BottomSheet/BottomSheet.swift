//
//  BottomSheet.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 10/04/21.
//

import UIKit

protocol BottomSheetDelegate: class {
    
    func didCameraButtonTapped()
    func didGalleryButtonTapped()
    func didDocumentBtnTapped()
}


class BottomSheet: UIView {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var galeryBtn: UIButton!
    @IBOutlet weak var filebtn: UIButton!
    
    var delegate : BottomSheetDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cameraBtn.layer.cornerRadius = 10.0
        galeryBtn.layer.cornerRadius = 10.0
        filebtn.layer.cornerRadius = 10.0
    }
    
    @IBAction func cameraBtnAction(_ sender: Any) {
        if delegate != nil {
             delegate!.didCameraButtonTapped()
         }
    }
    
    @IBAction func GalleryBtnAction(_ sender: Any) {
        if delegate != nil {
             delegate!.didGalleryButtonTapped()
         }
    }
    
    @IBAction func fileBtnAction(_ sender: Any) {
        if delegate != nil {
             delegate!.didDocumentBtnTapped()
         }
    }
    
}
