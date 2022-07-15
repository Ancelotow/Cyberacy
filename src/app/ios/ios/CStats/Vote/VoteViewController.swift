//
//  VoteViewController.swift
//  CStats
//
//  Created by Gabriel on 18/05/2022.
//

import UIKit

class VoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    //functions
    

    //Actions
    
    
    @IBAction func goToVoteNumber(_ sender: Any) {
        let statesVoteViewController = StatesVoteViewController()
        self.navigationController?.pushViewController(statesVoteViewController, animated: true)
    }
    
    @IBAction func goToPersonVote(_ sender: Any) {
        let statesVoteViewController = AbstentionViewController()
        self.navigationController?.pushViewController(statesVoteViewController, animated: true)
    }
    
    @IBAction func goToTrendsStates(_ sender: Any) {
        let statesVoteViewController = StatesVoteViewController()
        self.navigationController?.pushViewController(statesVoteViewController, animated: true)
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
    
    
    
    
}
