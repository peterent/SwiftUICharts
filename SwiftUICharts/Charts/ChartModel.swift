//
//  ChartModel.swift
//  Animations
//
//  Created by Peter Ent on 9/10/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import Foundation

// The ChartModel can be used to supply the data to the charts which are expecting
// percentage values. For example, if you have data representing temperatures from
// -32°F to 100°F, the model can convert the values into percentages and supply a
// label function to show the actual values.
//
class ChartModel: NSObject, ObservableObject {
    
    // The vector is what the charts use
    @Published var vector: AnimatableVector = AnimatableVector.zero
    
    // Set the model's data which will then transform it into the vector
    var data: [Double] = [0.0] {
        didSet {
            transformData()
        }
    }
    
    // Set the data's range if you do not want to use the data's own min and max
    // values. For example, if you temperatures do range from -32°F to 100°F, you
    // may want the chart to represent -100°F to 120°F so that a value of -32 does
    // not produce a 0 value in the vector.
    var dataRange: ClosedRange<Double>? {
        didSet {
            transformData()
        }
    }
    
    convenience init(dataRange: ClosedRange<Double>?) {
        self.init()
        self.dataRange = dataRange
    }
    
    // Creates the vector data by transforming the data along with the dataRange
    // (if present).
    func transformData() {
        var maxValue = Double.leastNormalMagnitude
        var minValue = Double.greatestFiniteMagnitude
        
        if let dataRange = dataRange {
            maxValue = dataRange.upperBound
            minValue = dataRange.lowerBound
        } else {
            data.forEach { (value) in
                maxValue = max(maxValue, value)
                minValue = min(minValue, value)
            }
        }
        
        let range = maxValue - minValue
        var vectorData = [Double]()
        
        for value in data {
            let datum = (value - minValue)/range
            vectorData.append(datum)
        }
        
        vector = AnimatableVector(values: vectorData)
    }
}
