//
//  UIViewController+Extension.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 10/14/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        TMDBClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
}
