//
//  AbstentionViewController.swift
//  CStats
//
//  Created by Gabriel on 07/07/2022.
//

import UIKit

class AbstentionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    
    @IBOutlet weak var tabViewStats: UITableView!
    var statsItem = [DataAbstention]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CStatesWebServices.getAbstention{ data in
            self.statsItem = data
            print(self.statsItem)
            DispatchQueue.main.async {
                self.tabViewStats.dataSource = self
                self.tabViewStats.delegate = self
                self.tabViewStats.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
            }
        }
    }


    // Actions
    
    @IBAction func goToGraph(_ sender: Any) {
        let graphViewController = GraphAbstentionViewController()
        self.navigationController?.pushViewController(graphViewController, animated: true)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func goToPP(_ sender: Any) {
        let partyViewController = PoliticPartyViewController()
            self.navigationController?.pushViewController(partyViewController, animated: false)
    }
    @IBAction func goToVote(_ sender: Any) {
        let voteViewController = VoteViewController()
            self.navigationController?.pushViewController(voteViewController, animated: false)
    }
    
    // Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabViewStats.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Élection " + statsItem[indexPath.row].name_election + " Nombre d'abstention : " + String(statsItem[indexPath.row].nb_abstention)
        
        cell.backgroundColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1)
        //cell.textLabel?.textColor = .white
        cell.layer.shadowColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1).cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 10)
        cell.layer.shadowOpacity = 4.0
        
        return cell
    }
    
}
