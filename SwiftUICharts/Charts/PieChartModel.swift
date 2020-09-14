//
//  PieChartModel.swift
//  SwiftUICharts
//
//  Created by Peter Ent on 9/13/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import Foundation

// This extension of ChartModel makes sure the values in the vector are the angles of
// the pie wedges. This model converts the data given into angles in one of these ways:
//
// 1. If the dataRange is nil, the values are summed to get a total and each value's
//    percentage of the total is converted into the vector. Negative values should not
//    be present. If they are, supply a dataRange.
// 2. If the dataRange is given, the data values are used to determine their percentage
//    of that range.
//
// The percentage values are then used to form angle sweeps for each wedge.
//
class PieChartModel: ChartModel {
    
    // Creates the vector data of angles (degress) based on the data
    override func transformData() {
        var vectorData: [Double] = [0]
        var startAngle: Double = 0
        
        if let dataRange = dataRange {
            let maxValue = dataRange.upperBound
            let minValue = dataRange.lowerBound
            let r = maxValue - minValue
            
            for value in data {
                let v1 = value - minValue
                let v2 = v1 / r
                let datum = v2 * 360
                vectorData.append(datum + startAngle)
                startAngle += datum
            }
        } else {
            let sum = data.reduce(0, +)
            
            for value in data {
                let datum = (value / sum) * 360
                vectorData.append(datum + startAngle)
                startAngle += datum
            }
        }
        
        vector = AnimatableVector(values: vectorData)
    }
}
