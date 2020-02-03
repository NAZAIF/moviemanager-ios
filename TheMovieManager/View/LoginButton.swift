//
//  LoginButton.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 09/17/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryDark
    }
    
}
