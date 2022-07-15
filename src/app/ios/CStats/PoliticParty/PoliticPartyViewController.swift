//
//  PoliticPartyViewController.swift
//  CStats
//
//  Created by Gabriel on 18/05/2022.
//

import UIKit

class PoliticPartyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    
    // Actions
    
    @IBAction func goToPP(_ sender: Any) {
        let statesPPViewController = StatesPoliticPartyViewController()
        self.navigationController?.pushViewController(statesPPViewController, animated: true)
    }
    
    @IBAction func goToMeet(_ sender: Any) {
                let meetViewController = MeetingViewController() //newInstance(meet: success!)
                self.navigationController?.pushViewController(meetViewController, animated: true)
                
            }
    
    @IBAction func goToMessage(_ sender: Any) {
        let messViewController = MessageViewController()
        self.navigationController?.pushViewController(messViewController, animated: true)
    }
    
    @IBAction func goToSondage(_ sender: Any) {
        let sondageViewController = SondageViewController()
        self.navigationController?.pushViewController(sondageViewController, animated: true)
    }
    
    @IBAction func goToMoney(_ sender: Any) {
        let cotisationViewController = CotisationViewController()
        self.navigationController?.pushViewController(cotisationViewController, animated: true)
    
    }
    
    
    
    // NavBar
    @IBAction func goToHome(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @IBAction func goToVote(_ sender: Any) {let voteViewController = VoteViewController()
        self.navigationController?.pushViewController(voteViewController, animated: true)
    }
    
    
    

}
