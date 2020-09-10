//
//  BarChartView.swift
//  Animations
//
//  Created by Peter Ent on 9/8/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

// Displays a BarChart with optional axis, grid, and even shadow. The data to chart
// is expected to be a vector of Double which represent percentages of the width of
// chart.
//
// A labelling function can be used to supply custom values, rather than percentages.
//
struct BarChartView: View {
    @ObservedObject var model: ChartModel
    var showsAxis = true
    var showGrid = false
    var showShadow = false
    var barColor = Color.green
    var axisColor = Color.gray
    var gridColor = Color(red: 0.85, green: 0.85, blue: 0.85)
    var label: (Double, Int) -> String = { (value, index) -> String in
        return String(format: "%.2f", value)
    }
    
    var body: some View {
        ZStack {
            if self.showGrid {
                GraphPaperView(numCells: 10, lineColor: self.gridColor)
            }
            
            BarChart(vector: self.model.vector)
                .fill(self.barColor)
                .clipped()
                .animation(.easeInOut(duration: 0.5))
                .if(self.showShadow) {
                    $0.shadow(radius: 6)
                }
            
            if self.showsAxis {
                AxisView()
                    .stroke(self.axisColor)
                    .animation(.easeInOut(duration: 0.5))
            }
            
            BarChartLabels(vector: self.model.vector, label: self.label)
        }
        .padding()
    }
}

// The bar chart consists of data defining the width of each bar from the left edge of the
// view. The widths are given in percentages of the view's width. For example, a vector
// of [0.5, 0.8, 1.0, 0.25] will have four bars each drawn as 50%, 80%, 100%, and 25%
// of the view's width.
//
// Note that the chart does not expect negative values. If you want to display negative
// values, then assume the values range from -100% to +100% and adjust the AxisView to
// draw the axis through the middle of the space at rect.width/2. You will have to
// adjust the calculation of width of each bar accordingly and send it either to the
// left or right of center depending on its sign.
//
struct BarChart: Shape {
    static let GapSize: CGFloat = 2
    static let BarLabelWidth: CGFloat = 200
    static let BarLabelOffset: CGFloat = 204
    
    var vector: AnimatableVector
    
    var animatableData: AnimatableVector {
        get { vector }
        set { vector = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        // determine the number of bars
        let numBars = vector.values.count
        // determine the height of each bar based on the GapSize
        let barHeight = (rect.height - BarChart.GapSize * CGFloat(numBars + 1)) / CGFloat(numBars)
        // set the starting location
        var ypos = BarChart.GapSize
        
        return Path { path in
            vector.values.forEach { (value) in
                let xvalue = rect.width * CGFloat(value)
                path.addRect(CGRect(x: 0, y: ypos, width: xvalue, height: barHeight))
                ypos += CGFloat(barHeight) + BarChart.GapSize
            }
        }
    }
}

struct BarChartLabels: View {
    var vector: AnimatableVector
    var label: (Double, Int) -> String
    
    // determines the bar height and gap spacing between the bars, reducing the
    // size of the bars if needed to accomodate a minimum 2 pixel gap between bars.
    func barSize(_ reader: GeometryProxy) -> CGFloat {
        let numBars = vector.values.count
        return (reader.size.height - BarChart.GapSize * CGFloat(numBars + 1)) / CGFloat(numBars)
    }
    
    func xposition(_ reader: GeometryProxy, index: Int) -> CGFloat {
        return reader.size.width * CGFloat(self.vector.values[index]) - BarChart.BarLabelOffset
    }
    
    func yposition(_ reader: GeometryProxy, index: Int) -> CGFloat {
        let barHeight = barSize(reader)
        return BarChart.GapSize + CGFloat(index) * barHeight + CGFloat(index) * BarChart.GapSize
    }
    
    var body: some View {
        GeometryReader { reader in
            ForEach(0..<self.vector.values.count, id: \.self) { index in
                Text(self.label(self.vector.values[index], index))
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: BarChart.BarLabelWidth, height: self.barSize(reader), alignment: .trailing)
                    .offset(x: self.xposition(reader, index: index),
                            y: self.yposition(reader, index: index))
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(model: ChartModel())
    }
}
