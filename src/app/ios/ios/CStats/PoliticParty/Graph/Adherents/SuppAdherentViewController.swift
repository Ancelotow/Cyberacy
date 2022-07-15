//
//  SuppAdherentViewController.swift
//  CStats
//
//  Created by Gabriel on 30/05/2022.
//

import UIKit
import Charts
import TinyConstraints

class SuppAdherentViewController: UIViewController, ChartViewDelegate  {

    // Outlets
    
    var statsItem = [DataAdherent]()
    // Functions
    
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
        self.navigationItem.hidesBackButton = true
        
        CStatesWebServices.getAdherent(sort: "year"){ [self] data in
            self.statsItem = data
            //print(self.statsItem[0].stats[0].year)
            DispatchQueue.main.async { [self] in
                self.view.addSubview(lineChartView)
                //lineChartView.frame(width: 20, height: CGFloat(self.sumPrecipitation(15)) * 15.0)
                self.lineChartView.bottomToSuperview(offset: 15, isActive: true, usingSafeArea: true)
                //lineChartView.rightToSuperview(offset: 2, isActive: true, usingSafeArea: true)
                //lineChartView.leftToSuperview(offset: 2, isActive: true, usingSafeArea: true)
                
                
                self.lineChartView.width(to: view)
                self.lineChartView.heightToWidth(of: view)
                
                self.setData()
            }
        }
        
    }
    
    
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
        
        
        let yValues: [ChartDataEntry] = [
            ChartDataEntry(x: Double(statsItem[0].stats[0].year), y: Double(statsItem[0].stats[0].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[1].year), y: Double(statsItem[0].stats[1].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[2].year), y: Double(statsItem[0].stats[2].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[3].year), y: Double(statsItem[0].stats[3].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[4].year), y: Double(statsItem[0].stats[4].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[5].year), y: Double(statsItem[0].stats[5].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[6].year), y: Double(statsItem[0].stats[6].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[7].year), y: Double(statsItem[0].stats[7].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[8].year), y: Double(statsItem[0].stats[8].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[9].year), y: Double(statsItem[0].stats[9].total)),
            ChartDataEntry(x: Double(statsItem[0].stats[10].year), y: Double(statsItem[0].stats[10].total))
        ]
        
        let set1 = LineChartDataSet(entries: yValues, label: "Adherents")
        
        //set1.mode = .cubicBezier
        //set1.drawCirclesEnabled = false
        set1.lineWidth = 5
        set1.setColor(.white)
        set1.fill = ColorFill(color: .cyan)
        set1.fillAlpha = 1
        set1.drawFilledEnabled = true
        
        //set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        //data.setDrawValues(false)
        lineChartView.data = data
        
        
    }
    
    

    

    // Actions
    
    @IBAction func goToMonth(_ sender: Any) {
        let statesPPViewController = StatesPoliticPartyViewController.newInstance(code: 1)
        self.navigationController?.pushViewController(statesPPViewController, animated: false)
    }
    
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
    @IBAction func goToBack(_ sender: Any) {
        let viewController = PoliticPartyViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    

}
