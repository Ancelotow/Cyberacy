//
//  CotisationViewController.swift
//  CStats
//
//  Created by Gabriel on 22/06/2022.
//

import UIKit

class CotisationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    
    @IBOutlet weak var tabViewStats: UITableView!
    var statsItem = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CStatesWebServices.MessStats{ data in
            self.statsItem = data
            print(self.statsItem)
            DispatchQueue.main.async {
                self.tabViewStats.dataSource = self
                self.tabViewStats.delegate = self
                self.tabViewStats.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
            }
        }
    }


    // ACTIONS
    
    
    @IBAction func goToGraphCotisation(_ sender: Any) {
        let graphcotisationViewController = GraphCotisationViewController()
        self.navigationController?.pushViewController(graphcotisationViewController, animated: true)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func goToParty(_ sender: Any) {
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
        cell.textLabel?.text = statsItem[indexPath.row].publishedAt
        
        cell.backgroundColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1)
        //cell.textLabel?.textColor = .white
        cell.layer.shadowColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1).cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 10)
        cell.layer.shadowOpacity = 4.0
        
        return cell
    }
    

}
