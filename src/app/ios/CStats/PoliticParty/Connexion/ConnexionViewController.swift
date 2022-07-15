//
//  ConnexionViewController.swift
//  CStats
//
//  Created by Gabriel on 12/05/2022.
//

import UIKit

class ConnexionViewController: UIViewController, UITextFieldDelegate {
    
    
    // Outlets
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var labelMissing: UILabel!
    @IBOutlet weak var labelWrong: UILabel!
    
    
    @IBOutlet weak var validateButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        validateButton.layer.cornerRadius = 30
    }
    
    // Private functions
    private func setupTextField(){
        pseudoTextField.delegate = self
        passwordTextField.delegate = self
        
        // Close keyboard with a tap on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }

    // Actions
    
    @IBAction func goHomePage(_ sender: Any) {
        if pseudoTextField.text != "" && passwordTextField.text != "" {
            
            CStatesWebServices.connectUser(pseudo: pseudoTextField.text!, password: passwordTextField.text!){ err, success in
                    guard (success != nil) else {
                        return
                    }
                    DispatchQueue.main.async {
                        if (UserSession.getInstance() == nil){
                            self.labelWrong.textColor = UIColor.red
                        }else{
//                            let session = UserSession.getInstance()
//                            let tok = session?.getToken()
//                            print(tok)
                            let homePageViewController = HomePageViewController()
                            self.navigationController?.pushViewController(homePageViewController, animated: true)
                        }
                        
                    }
            }
        }else{
            labelMissing.textColor = UIColor.red
        }
        
    }
    
    @IBAction func goInscription(_ sender: Any) {
        let inscriptionViewController = InscriptionViewController()
        self.navigationController?.pushViewController(inscriptionViewController, animated: true)
    }
    
    @objc private func hideKeyboard(){
        pseudoTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
