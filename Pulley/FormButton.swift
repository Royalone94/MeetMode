//
//  FormButton.swift
//  tourvision
//
//  Created by my on 2019/8/9.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit

@IBDesignable
class FormButton: UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
