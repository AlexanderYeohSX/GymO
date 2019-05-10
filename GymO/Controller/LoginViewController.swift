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
    var activeField: UITextField?
    
    
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
        
        loginScrollView.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        ///Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        registerForKeyboardNotifications()
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
    
    @objc func keyboardWasShown(notification: NSNotification){
        
        if let info = notification.userInfo, let keyboardFrameEndUserInfoKey = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var keyboardRect: CGRect = keyboardFrameEndUserInfoKey.cgRectValue
            keyboardRect = self.view.convert(keyboardRect, from: nil)
            let keyboardTop = keyboardRect.origin.y
            
            var newScrollViewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: keyboardTop)
            newScrollViewFrame.size.height = keyboardTop - self.view.bounds.origin.y
            self.loginScrollView.frame = newScrollViewFrame
            
            if let _activeField = self.activeField {
                self.loginScrollView.scrollRectToVisible(_activeField.frame, animated: true)
            }
            
            loginScrollView.isScrollEnabled = true
        }
    
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        
        let defaultFrame = CGRect(x: self.loginScrollView.frame.origin.x, y: self.loginScrollView.frame.origin.y, width: self.view.frame.size.width, height:  self.view.frame.size.height)
        
        self.loginScrollView.frame = defaultFrame
        let topFrame = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
        self.loginScrollView.scrollRectToVisible(topFrame, animated: true)
        
        loginScrollView.isScrollEnabled = false
        activeField = nil
    }
    
 
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    
}

extension LoginViewController: UIScrollViewDelegate {
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
       NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeField = textField
        
    }
}
