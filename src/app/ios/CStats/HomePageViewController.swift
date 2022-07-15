//
//  HomePageViewController.swift
//  CStats
//
//  Created by Gabriel on 12/05/2022.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    // Actions
    
    // PP
    
    @IBAction func goToAdhérents(_ sender: Any) {
        let addViewController = StatesPoliticPartyViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    @IBAction func goToSondage(_ sender: Any) {
        let sondageViewController = SondageViewController()
        self.navigationController?.pushViewController(sondageViewController, animated: true)
    }
    
    @IBAction func goToMeet(_ sender: Any) {
        let meetViewController = MeetingViewController()
        self.navigationController?.pushViewController(meetViewController, animated: true)
    }

    // Vote
    
    
    @IBAction func goToParticipation(_ sender: Any) {
        let viewController = StatesVoteViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func goToAbstention(_ sender: Any) {
        let viewController = AbstentionViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func goToResult(_ sender: Any) {
        let viewController = ResultViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    // NavBar
    @IBAction func goPoliticParty(_ sender: Any) {
        let politicPartyViewController = PoliticPartyViewController()
        self.navigationController?.pushViewController(politicPartyViewController, animated: true)
    }
    
    @IBAction func goVote(_ sender: Any) {
        let voteViewController = VoteViewController()
        self.navigationController?.pushViewController(voteViewController, animated: true)
    }
    
    
    
    
    
}
