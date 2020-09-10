//
//  ColumnChart.swift
//  Animations
//
//  Created by Peter Ent on 9/8/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

// Displays a ColumnChart with optional axis, grid, and even shadow. The data to chart
// is expected to be a vector of Double which represent percentages of the height of
// chart.
//
// A labelling function can be used to supply custom values, rather than percentages.
//
struct ColumnChartView: View {
    @ObservedObject var model: ChartModel
    var showsAxis = true
    var showGrid = false
    var showShadow = false
    var columnColor = Color.green
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
            
            ColumnChart(vector: self.model.vector)
                .fill(self.columnColor)
                .clipped()
                .animation(.easeInOut(duration: 0.5))
                .if(self.showShadow) {
                    $0.shadow(radius: 6)
                }
            
            if showsAxis {
                AxisView()
                    .stroke(self.axisColor)
            }
            
            ColumnChartLabels(vector: self.model.vector, label: self.label)
        }
        .padding()
    }
}

// The column chart consists of data defining the height of each column from the bottom edge of the
// view. The heights are given in percentages of the view's height. For example, a vector
// of [0.5, 0.8, 1.0, 0.25] will have four columns each drawn as 50%, 80%, 100%, and 25%
// of the view's height.
//
// Note that the chart does not expect negative values. If you want to display negative
// values, then assume the values range from -100% to +100% and adjust the AxisView to
// draw the axis through the middle of the space at rect.height/2. You will have to
// adjust the calculation of height of each bar accordingly and send it either above or
// below the center depending on its sign.
//
struct ColumnChart: Shape {
    static let GapSize: CGFloat = 2
    static let ColumnLabelHeight: CGFloat = 30
    static let ColumnLabelOffset: CGFloat = 2
    
    var vector: AnimatableVector
    
    var animatableData: AnimatableVector {
        get { vector }
        set { vector = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        // determine the number of columns
        let numColumns = vector.values.count
        // determine the width of each column based on the GapSize
        let columnWidth = (rect.width - ColumnChart.GapSize * CGFloat(numColumns + 1)) / CGFloat(numColumns)
        // set the starting location
        var xpos = ColumnChart.GapSize
        
        return Path { path in
            vector.values.forEach { (value) in
                let yvalue = rect.height * CGFloat(value)
                path.addRect(CGRect(x: xpos, y: rect.height - yvalue, width: CGFloat(columnWidth), height: yvalue))
                xpos += CGFloat(columnWidth) + ColumnChart.GapSize
            }
        }
    }
}

struct ColumnChartLabels: View {
    var vector: AnimatableVector
    var label: (Double, Int) -> String
    
    // determines the column width and gap spacing between the columns, reducing
    // the size of the columns if needed to accomodate a minimu 2 pixel gap between
    // columns.
    func columnSize(_ reader: GeometryProxy) -> CGFloat {
        let numCols = vector.values.count
        return (reader.size.width - ColumnChart.GapSize * CGFloat(numCols + 1)) / CGFloat(numCols)
    }
    
    func xposition(_ reader: GeometryProxy, index: Int) -> CGFloat {
        let columnWidth = columnSize(reader)
        return ColumnChart.GapSize + CGFloat(index) * columnWidth + CGFloat(index) * ColumnChart.GapSize
    }
    
    func yposition(_ reader: GeometryProxy, value: Double) -> CGFloat {
        return reader.size.height - reader.size.height * CGFloat(value) + ColumnChart.ColumnLabelOffset
    }
    
    var body: some View {
        GeometryReader { reader in
            ForEach(0..<self.vector.values.count, id: \.self) { index in
                Text(self.label(self.vector.values[index], index))
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: self.columnSize(reader), height: ColumnChart.ColumnLabelHeight, alignment: .top)
                    .offset(x: self.xposition(reader, index: index),
                            y: self.yposition(reader, value: self.vector.values[index]))
            }
        }
    }
}

struct ColumnChart_Previews: PreviewProvider {
    static var previews: some View {
        ColumnChartView(model: ChartModel())
    }
}
