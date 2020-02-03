//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Moideen Nazaif VM on 10/02/19.
//  Copyright © 2019 Moideen Nazaif VM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(success:error:))
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print(TMDBClient.Auth.requestToken)
            DispatchQueue.main.async {
                TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))

            }
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print(TMDBClient.Auth.requestToken)
        if success {
            TMDBClient.getSessionId(completion: handleSessionRequest(success:error:))
        } else {
            passwordTextField.text = ""
            let alertController = UIAlertController(title: "Error Logging in", message: error?.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func handleSessionRequest(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        }
    }
    
    @IBAction func loginViaWebsiteTapped() {
        TMDBClient.getRequestToken { (success, error) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
}
