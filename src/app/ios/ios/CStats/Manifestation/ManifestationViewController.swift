//
//  ManifestationViewController.swift
//  CStats
//
//  Created by Gabriel on 18/05/2022.
//

import UIKit

class ManifestationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //functions
    
    private func goTo(code: Int){
        let statesManifViewController = StatesManifestationViewController.newInstance(code: code)
        self.navigationController?.pushViewController(statesManifViewController, animated: true)
    }


    // Actions
    
    @IBAction func goToManifestationNumber(_ sender: Any) {
        goTo(code: 1)
    }
    
    @IBAction func goToPlace(_ sender: Any) {
        goTo(code: 2)
    }
    
    @IBAction func goToChooseOption(_ sender: Any) {
        goTo(code: 3)
    }
    
    @IBAction func goToNumberParticipate(_ sender: Any) {
        goTo(code: 4)
    }
    
    @IBAction func goToOpinion(_ sender: Any) {
        goTo(code: 5)
    }
    
    
    // NavBar
    @IBAction func goToHome(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @IBAction func goToPoliticParty(_ sender: Any) {
        let politicPartyViewController = PoliticPartyViewController()
        self.navigationController?.pushViewController(politicPartyViewController, animated: true)
    }
    
    @IBAction func goToVote(_ sender: Any) {
        let voteViewController = VoteViewController()
            self.navigationController?.pushViewController(voteViewController, animated: true)
    }
    

}
