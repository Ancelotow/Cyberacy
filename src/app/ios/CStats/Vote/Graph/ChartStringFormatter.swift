//
//  XAxisValueFormatter.swift
//  CStats
//
//  Created by Gabriel on 14/07/2022.
//

import Foundation
import UIKit
import Charts

class ChartStringFormatter: NSObject {
    
    var nameValues: [String]!
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}
