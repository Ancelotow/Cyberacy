//
//  MeetingViewController.swift
//  CStats
//
//  Created by Gabriel on 12/06/2022.
//

import UIKit

class MeetingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    // Outlets
    
    @IBOutlet weak var tabViewstats: UITableView!
    var statsItem = [DataMeet]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CStatesWebServices.getMeet{ data in
            self.statsItem = data
            print(self.statsItem)
            DispatchQueue.main.async {
                self.tabViewstats.dataSource = self
                self.tabViewstats.delegate = self
                self.tabViewstats.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
            }
        }
  
    }
    
    // Actions
    @IBAction func goToGraph(_ sender: Any) {
        let graphMeet = GraphMeetViewController()
        self.navigationController?.pushViewController(graphMeet, animated: true)
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
        let cell = tabViewstats.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Partie politique : " + statsItem[indexPath.row].name
        
        cell.backgroundColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1)
        cell.textLabel?.textColor = .black
        cell.layer.shadowColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1).cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 10)
        cell.layer.shadowOpacity = 4.0
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meetId = self.statsItem[indexPath.row].id
        
        
        let nextController = ItemMeetViewController.newInstance(id: meetId)
        self.navigationController?.pushViewController(nextController, animated: true)
            }
    
    
}
