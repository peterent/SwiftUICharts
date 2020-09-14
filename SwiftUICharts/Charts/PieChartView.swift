//
//  PieChartView.swift
//  SwiftUICharts
//
//  Created by Peter Ent on 9/13/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    @ObservedObject var model: PieChartModel
    var showGrid = false
    var showShadow = false
    var gridColor = Color(red: 0.85, green: 0.85, blue: 0.85)
    var colors = [
        Color.blue,
        Color.red,
        Color.green,
        Color.orange,
        Color.purple,
        Color.yellow,
        Color(red: 0.1, green: 0.75, blue: 0.75),
        Color.gray,
        Color.black]
    var label: (Double, Int) -> String = { (value, index) -> String in
        return String(format: "%.2f", value)
    }
    
    var body: some View {
        ZStack {
            if self.showGrid {
                GraphPaperView(numCells: 10, lineColor: self.gridColor)
            }
            PieChart(vector: self.model.vector, colors: self.colors)
                .clipped()
                .animation(.easeInOut(duration: 0.5))
                .if(self.showShadow) {
                    $0.shadow(radius: 6)
            }
            
            PieChartLabels(vector: self.model.vector, label: self.label)
        }
    }
}

struct PieChart: View {
    var vector: AnimatableVector
    var colors: [Color]
    
    var body: some View {
        ZStack {
            ForEach(1..<vector.values.count, id: \.self) { index in
                Wedge(startAngle: self.vector.values[index-1],
                      endAngle: self.vector.values[index])
                    .fill(self.colors[index % self.colors.count])
            }
        }
    }
}

fileprivate struct Wedge: Shape {
    var startAngle: Double
    var endAngle: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair<Double, Double>(startAngle, endAngle) }
        set { (startAngle, endAngle) = (newValue.first, newValue.second) }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.width/2, y: rect.height/2))
            let r = min(rect.width/2, rect.height/2)
            path.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: r, startAngle: .init(degrees: startAngle), endAngle: .degrees(endAngle), clockwise: false)
            path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
        }
    }
}

struct PieChartLabels: View {
    var vector: AnimatableVector
    var label: (Double, Int) -> String
    
    func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let radians = CGFloat.pi * angle / 180
        let x = center.x + radius * cos(radians)
        let y = center.y + radius * sin(radians)
        
        return CGPoint(x: x, y: y)
    }
    
    func position(_ reader: GeometryProxy, index: Int) -> CGSize {
        let r: CGFloat = min(reader.size.width/2, reader.size.height/2) * 0.75
        let c = CGPoint(x: reader.size.width/2, y: reader.size.height/2)
        let middle = degreesFor(index)
        let p = self.pointOnCircle(center: c, radius: r, angle: CGFloat(middle))
        return CGSize(width: p.x-20, height: p.y-10)
    }
    
    func degreesFor(_ index: Int) -> Double {
        let angle1 = self.vector.values[index]
        let angle2 = self.vector.values[index+1]
        return (angle1 + angle2) / 2
    }
        
    var body: some View {
        GeometryReader { reader in
            ForEach(0..<self.vector.values.count-1, id: \.self) { index in
                Text(self.label(self.vector.values[index], index))
                    .font(.caption)
                    .frame(width: 40, height: 20, alignment: .center)
                    .foregroundColor(.white)
                    .offset(self.position(reader, index: index))
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(model: PieChartModel())
    }
}
