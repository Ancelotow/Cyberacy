//
//  GraphCotisationViewController.swift
//  CStats
//
//  Created by Gabriel on 22/06/2022.
//

import UIKit
import Charts
import TinyConstraints

class GraphCotisationViewController: UIViewController {

    // Outlets:
    
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemGreen
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 20)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 20)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .white
        
        chartView.animate(xAxisDuration: 1.0)
        
        
        return chartView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lineChartView)
        lineChartView.bottomToSuperview(offset: 20, isActive: true, usingSafeArea: true)
        //lineChartView.centerInSuperview()
        
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        setData()
        
        
    }
    
    // functions
    var code : Int!
    
    public class func newInstance(code: Int) -> StatesPoliticPartyViewController{
            let tlvc = StatesPoliticPartyViewController()
            tlvc.code = code
            return tlvc
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Cotisation")
        
        //set1.mode = .cubicBezier
        //set1.drawCirclesEnabled = false
        set1.lineWidth = 5
        set1.setColor(.white)
        set1.fill = ColorFill(color: .white)
        set1.fillAlpha = 1
        set1.drawFilledEnabled = true
        
        //set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        //data.setDrawValues(false)
        lineChartView.data = data
    }
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 1.0),
        ChartDataEntry(x: 2.0, y: 7.0),
        ChartDataEntry(x: 3.0, y: 15.0),
        ChartDataEntry(x: 4.0, y: 12.0),
        ChartDataEntry(x: 5.0, y: 6.0),
        ChartDataEntry(x: 6.0, y: 3.0),
        ChartDataEntry(x: 7.0, y: 20.0),
        ChartDataEntry(x: 8.0, y: 16.0),
        ChartDataEntry(x: 9.0, y: 19.0),
        ChartDataEntry(x: 10.0, y: 12.0),
        ChartDataEntry(x: 11.0, y: 13.0),
        ChartDataEntry(x: 12.0, y: 13.0),
    ]

    // Actions
    
    @IBAction func goToHome(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func goToPP(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func goToVote(_ sender: Any) {
        let homeViewController = HomePageViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    
    
  

}
