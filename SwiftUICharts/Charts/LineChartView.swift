//
//  LineChartView.swift
//  SwiftUICharts
//
//  Created by Peter Ent on 9/13/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

// Displays a LineChart with optional axis, grid, and even shadow. The data to the chart
// is expected to be a vector of Double which represent percentages of the height of the
// chart.
//
// A labelling function can be used to supply custom values, rather than percentages.
//
struct LineChartView: View {
    @ObservedObject var model: ChartModel
    var showsAxis = true
    var showGrid = false
    var showShadow = false
    var lineColor = Color.green
    var lineWidth: CGFloat = 3
    var axisColor = Color.gray
    var gridColor = Color(red: 0.85, green: 0.85, blue: 0.85)
    var label: (Double, Int) -> String = { (value, index) -> String in
        return String(format: "%.2f", value)
    }
    
    // Idea: supply a labelColor function that given the index returns a color to use
    // for the label. The default would just return Black.
    
    var body: some View {
        ZStack {
            if self.showGrid {
                GraphPaperView(numCells: 10, lineColor: self.gridColor)
            }
            
            LineChart(vector: self.model.vector)
                .stroke(self.lineColor, style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round))
                .clipped()
                .animation(.easeInOut(duration: 0.5))
                .if(self.showShadow) {
                    $0.shadow(radius: 6)
            }
            
            if showsAxis {
                AxisView()
                    .stroke(self.axisColor)
            }
            
            LineChartLabels(vector: self.model.vector, label: self.label)
        }
        .padding()
    }
}

// The LineChart consists of data defining the height of the line at each data point from the bottom edge
// of the view. The heights are given in percentages of the view's height. For example, a vector of [0.5,
// 0.8, 1.0, 0.25] will display a line of four points at the 50%, 80%, 100%, and 25% height marks (actually
// a little less as there is a small gutter at the top to account for label height).
//
// Note that the chart does not expect negative values. If you want to display negative
// values, then assume the values range from -100% to +100% and adjust the AxisView to
// draw the axis through the middle of the space at rect.height/2. You will have to
// adjust the calculation of height of each bar accordingly and send it either above or
// below the center depending on its sign.
//
struct LineChart: Shape {
    static let LineLabelGutter: CGFloat = 10
    
    var vector: AnimatableVector
    
    var animatableData: AnimatableVector {
        get { vector }
        set { vector = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        // determine the number of points
        let numPoints = vector.values.count
        // determine the spacing between the points
        let spacing = (rect.width) / CGFloat(numPoints + 1)
        // set the starting position
        var xpos = spacing
        
        return Path { path in
            var points = [CGPoint]()
            vector.values.forEach { (value) in
                let yvalue = (rect.height - LineChart.LineLabelGutter) * CGFloat(value)
                points.append(CGPoint(x: xpos, y: rect.height - yvalue))
                xpos += spacing
            }
            path.addLines(points)
        }
    }
}

struct LineChartLabels: View {
    var vector: AnimatableVector
    var label: (Double, Int) -> String
    
    // determines the spacing between the verticies of the line segments.
    func spacing(_ reader: GeometryProxy) -> CGFloat {
        let numPoints = vector.values.count
        return (reader.size.width) / CGFloat(numPoints + 1)
    }
    
    // determines the specific horizontal position of each vertex.
    func xposition(_ reader: GeometryProxy, index: Int) -> CGFloat {
        let spacing = self.spacing(reader)
        return spacing + spacing * CGFloat(index)
    }
    
    // returns the verticial position of a given vertex.
    func yposition(_ reader: GeometryProxy, value: Double) -> CGFloat {
        let yvalue = (reader.size.height - LineChart.LineLabelGutter) * CGFloat(value)
        return reader.size.height - yvalue - 10
    }
    
    var body: some View {
        GeometryReader { reader in
            ForEach(0..<self.vector.values.count, id: \.self) { index in
                Text(self.label(self.vector.values[index], index))
                    .font(.caption)
                    .foregroundColor(.black)
                    .offset(x: self.xposition(reader, index: index),
                            y: self.yposition(reader, value: self.vector.values[index]))
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(model: ChartModel())
    }
}
