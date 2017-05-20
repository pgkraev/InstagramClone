//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Паша on 14/04/2017.
//  Copyright © 2017 Pavel Kraev. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // costomize emailTextField
        emailTextField.backgroundColor = .clear
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        
        // costomize passwordTextField
        passwordTextField.backgroundColor = .clear
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        signInButton.isEnabled = false
        
        handleTextField()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Api.User.currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }, onError: { error in
            ProgressHUD.showError(error!)
            print(error!)
        })
        
    }
    
}
