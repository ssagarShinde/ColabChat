//
//  ImageView.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 19/05/21.
//

import UIKit

protocol ImageViewDelegate: class {
    func didCancelImageViewButtonTapped()
}

class ImageView: UIView {
    @IBOutlet weak var fullscreenImage: UIImageView!
    
    var delegate : ImageViewDelegate?

    @IBAction func cancelBtnAction(_ sender: Any) {
        if delegate != nil {
             fullscreenImage.image = nil
             delegate!.didCancelImageViewButtonTapped()
         }
    }
}
