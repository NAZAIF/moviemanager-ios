//
//  LoginTextField.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 09/22/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.size.width - 16, height: bounds.size.height)
        return insetBounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.size.width - 16, height: bounds.size.height)
        return insetBounds
    }
    
}
