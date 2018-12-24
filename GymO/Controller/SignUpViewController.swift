//
//  SignUpViewController.swift
//  GymO
//
//  Created by Catherine on 11/24/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let loginSegue = "LoginSegue"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signUp(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!){(message) in
                
                if message != nil {
                    self.alertUser(title: "Problem With Creating User", message: message!)
                } else {
                    print("Creating User Complete")
                    //need to change to instantiate the master view controller
                    self.performSegue(withIdentifier: self.loginSegue, sender: self)                }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
