//
//  SignUpViewController.swift
//  GymO
//
//  Created by Catherine on 11/24/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
    
    private let loginSegue = "LoginSegue"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var textLabelViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for textLabelView in textLabelViews {
            textLabelView.layer.cornerRadius = ViewConstants.loginAndSignUpCornerRadius(viewHeight:  textLabelView.layer.frame.height)
        }
        
        signUpButton.layer.cornerRadius = ViewConstants.loginAndSignUpCornerRadius(viewHeight:  signUpButton.layer.frame.height)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        ///Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
    }
    
    
    
    @IBAction func signUp(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!){(message) in
                
                if message != nil {
                    self.alertUser(title: "Problem With Creating User", message: message!)
                } else {
                    print("Creating User Complete")
                    //need to change to instantiate the master view controller
                    self.performSegue(withIdentifier: "GoToFirstCustomization", sender: nil)
                    //self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            alertUser(title: "No Email/Password", message: "Please Enter An Email & Password")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension SignUpViewController {
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
