//
//  SignupViewController.swift
//  Dikke Ploaten
//
//  Created by Victor Vanhove on 14/03/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    weak var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    // Change size of scrollView and scroll to field
    @objc func keyboardWillShow(notification: NSNotification) {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    // Undo the above
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Actions
    @IBAction func signUpUser(_ sender: Any) {
        if validForm() {
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
                if error == nil {
                    // Save user data to database
                    let db = Firestore.firestore()
                    db.collection("users").document(user!.user.uid).setData(["username": self.txtUser.text!,
                                                                             "password": self.txtPassword.text!, "email": self.txtEmail.text!])
                    { err in
                        // Error adding user to database
                        if let err = err {
                            print("Error adding document: \(err)")
                        }
                    }
                    
                    // Go to next view
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                } else {
                    // Error creating user
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Controlling the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtUser:
            txtEmail.becomeFirstResponder()
        case txtEmail:
            txtPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            signUpUser(textField)
        }
        return true
    }
    
    // Check if form is valid
    private func validForm() -> Bool {
        var isValid: Bool = true
        
        // Check name
        lblUser.textColor = UIColor.black
        if txtUser.text!.isEmpty {
            isValid = false
        }
        
        // Check email
        lblEmail.textColor = UIColor.black
        if txtEmail.text!.isEmpty {
            isValid = false
        }
        
        // Check password
        lblPassword.textColor = UIColor.black
        if txtPassword.text!.isEmpty {
            isValid = false
        }
        
        if !isValid {
            // Show alert if form is not filled in correctly
            let alertController = UIAlertController(title: "Whoops", message: "Please make sure all required fields are filled out correctly.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        return isValid
    }

}
