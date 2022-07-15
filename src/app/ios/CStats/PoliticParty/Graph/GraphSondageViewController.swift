//
//  GraphSondageViewController.swift
//  CStats
//
//  Created by Gabriel on 21/06/2022.
//

import UIKit
import Charts
import TinyConstraints

class GraphSondageViewController: UIViewController, ChartViewDelegate {

    // Outlets:
    
    var barChart = BarChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        barChart.center = view.center
        
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        
        for x in 0..<12{
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
    
    // Actions
    
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
    
  

}
