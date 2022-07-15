//
//  GraphStatesVoteViewController.swift
//  CStats
//
//  Created by Gabriel on 07/07/2022.
//

import UIKit
import Charts
import TinyConstraints

class GraphStatesVoteViewController: UIViewController, ChartViewDelegate {

    // Outlets:
    
    var barChart = BarChartView()
    var statsItem = [DataParticipation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CStatesWebServices.getParticipation { data in
            self.statsItem = data
            print("self.statsItem-------")
            print(self.statsItem[0].name_election)
            DispatchQueue.main.async {
                self.barChart.delegate = self
            }
        }
    }
    
    
    // Functions
    
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
        
        let yAxis = barChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 20)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.labelPosition = .outsideChart
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 20)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .black
        xAxis.axisLineColor = .black
        
        barChart.rightAxis.enabled = false
        barChart.animate(xAxisDuration: 1.0)
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
    
    // Actions
    


    
}
