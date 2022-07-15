//
//  ItemMeetViewController.swift
//  CStats
//
//  Created by Gabriel on 10/07/2022.
//

import UIKit

class ItemMeetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // Outlets
    
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var tabViewDet: UITableView!
    @IBOutlet weak var labelPP: UILabel!
    
    var statsItem = [DataMeet]()
    var statsItemDet = [Stat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CStatesWebServices.getMeetDet(id: id){ data in
            self.statsItemDet = data[0].stats
            //print(sel/Users/gabriel/Documents/ESGI/TroisiemeAnnee/ProjetAnnuel/Application IOS/Cyberacy/src/app/ios/CStats/PoliticParty/PoliticPartyViewController.swiftf.statsItem[0].stats[0].year)
            DispatchQueue.main.async {
                self.labelPP.text = data[0].name
                self.tabViewDet.dataSource = self
                self.tabViewDet.delegate = self
                self.tabViewDet.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
            }
        }
    }
    
    
    // Actions
    
    
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
    
    var id : Int!
    
    
    public class func newInstance(id: Int) -> ItemMeetViewController{
            let tlvc = ItemMeetViewController()
            tlvc.id = id
            return tlvc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsItemDet.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabViewDet.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Année: " + String(statsItemDet[indexPath.row].year) + ", total participant: " + String(statsItemDet[indexPath.row].total_participant) + ", total meeting: " + String(statsItemDet[indexPath.row].total_meeting)
        
        cell.backgroundColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1)
        cell.textLabel?.textColor = .black
        cell.layer.shadowColor = UIColor(red: 242.0/255, green: 254.0/255, blue: 224.0/255, alpha: 1).cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 10)
        cell.layer.shadowOpacity = 4.0
        
        
        return cell
    }
    

}
