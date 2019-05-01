//
//  SignInViewController.swift
//  GymAlk
//
//  Created by Catherine on 7/28/18.
//  Copyright © 2018 GymAlk. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private let loginSegue = "LoginSegue"
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var passwordTextFieldView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        emailTextFieldView.layer.cornerRadius = ViewConstants.loginAndSignUpCornerRadius(viewHeight:  emailTextFieldView.layer.frame.height)
        passwordTextFieldView.layer.cornerRadius = ViewConstants.loginAndSignUpCornerRadius(viewHeight:  passwordTextFieldView.layer.frame.height)
        signInButton.layer.cornerRadius = ViewConstants.loginAndSignUpCornerRadius(viewHeight:  signInButton.layer.frame.height)
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        ///Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            self.performSegue(withIdentifier: self.loginSegue, sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func login(_ sender: Any) {
        
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!){ (message) in
                
                if message != nil {
                    self.alertUser(title: "Problem With Authentication", message: message!)
                } else {
                    print("Login Successful")
                    self.performSegue(withIdentifier: self.loginSegue, sender: nil)
                    
                }
            }
        } else {
            alertUser(title: "No Email/Password", message: "Please Enter An Email & Password")
        }
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!){(message) in
                
                if message != nil {
                    self.alertUser(title: "Problem With Creating User", message: message!)
                } else {
                    print("Creating User Complete")
                    self.performSegue(withIdentifier: self.loginSegue, sender: nil)
                }
            }
            
        } else {
            alertUser(title: "No Email/Password", message: "Please Enter An Email & Password")
        }
    }
    
    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController {
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
