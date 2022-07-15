//
//  InscriptionViewController.swift
//  CStats
//
//  Created by Gabriel on 12/05/2022.
//

import UIKit

class InscriptionViewController: UIViewController {

    // Outlets
    
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var postalTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    
    @IBOutlet weak var labelMissing: UILabel!
    
    @IBOutlet weak var validateButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design
        setupButton()
        setupTextField()
    }
    
    

    
    // Private functions
    private func setupButton(){
        validateButton.layer.cornerRadius = 20
    }
    
    private func setupTextField(){
        pseudoTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        newPasswordTextField.delegate = self
        nameTextField.delegate = self
        surnameTextField.delegate = self
        adressTextField.delegate = self
        postalTextField.delegate = self
        
        // Close keyboard with a tap on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    // Actions
    
    
    @IBAction func goInscriptionMessage(_ sender: Any) {
        if pseudoTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && newPasswordTextField.text != "" && passwordTextField.text == newPasswordTextField.text {
            
            
            CStatesWebServices.addUser(pseudo: pseudoTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, surname: surnameTextField.text!, address: adressTextField.text!, postal: postalTextField.text!,date: dateField.date){ err, success in
                    guard (success != nil) else {
                        return
                    }
                    DispatchQueue.main.async {
                        let inscriptionMessViewController = InscriptionMessViewController()
                        self.navigationController?.pushViewController(inscriptionMessViewController, animated: true)
                    }
                    }
        }else{
            labelMissing.textColor = UIColor.red
        }

    }
    
    @IBAction func goToConnexion(_ sender: Any) {
        let connexionViewController = ConnexionViewController()
        self.navigationController?.pushViewController(connexionViewController, animated: true)
    }
    

    @objc private func hideKeyboard(){
        pseudoTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        adressTextField.resignFirstResponder()
        postalTextField.resignFirstResponder()
    }

}

// Use textField
extension InscriptionViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

