//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by ChuckLiu on 8/03/21.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.clearsOnBeginEditing = true
        }
    }
    
    var resignationHandler: (()-> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
//        textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
