//
//  InscriptionMessViewController.swift
//  CStats
//
//  Created by Gabriel on 12/05/2022.
//

import UIKit

class InscriptionMessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goReturnConnexion(_ sender: Any) {
        let connexionViewController = ConnexionViewController()
        self.navigationController?.pushViewController(connexionViewController, animated: true)
    }
    
}
