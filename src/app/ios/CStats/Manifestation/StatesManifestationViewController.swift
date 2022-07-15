//
//  StatesManifestationViewController.swift
//  CStats
//
//  Created by Gabriel on 18/05/2022.
//

import UIKit

class StatesManifestationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //COMMENTAIRE A RETIRER EN PROD ---->
        print(self.code)
        /*if code == 1 {
            print(self.code)
        }
        else{
            print("Pas 1 mais", code)
        }
         */
        //<----
    }
    
    
    // functions
    var code : Int!
    
    public class func newInstance(code: Int) -> StatesManifestationViewController{
            let tlvc = StatesManifestationViewController()
            tlvc.code = code
            return tlvc
    }

}
