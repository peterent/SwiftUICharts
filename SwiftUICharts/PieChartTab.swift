//
//  PieChartTab.swift
//  SwiftUICharts
//
//  Created by Peter Ent on 9/14/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

struct PieChartTab: View {
    
    // Create the ChartModel used in the sample. The PieChart uses a slightly
    // different model than the other charts as it sets up its vector data
    // to be the angles for each wedge of the pie.
    @ObservedObject var model = PieChartModel()
    
    @State private var toggle = true
    @State private var showGrid = false
    @State private var showShadow = false
    
    let pieData1: [Double] = [5, 20, 50, 25, 30]
    let pieData2: [Double] = [10, 30, 20, 60, 40]
    
    // initialize this view with the first data set
    init() {
        self.model.data = self.pieData1
    }
    
    // uses a formatter to display the data values rather than the angles which
    // would be its default.
    var body: some View {
        VStack {
            PieChartView(model: self.model,
                         showGrid: self.showGrid,
                         showShadow: self.showShadow) { (_, index) in
                            String(format: "%.0f", self.model.data[index])
            }
            
            ChartControlBar(showGrid: self.$showGrid, showShadow: self.$showShadow) {
                self.toggle.toggle()
                
                // switch the model in the data which will trigger the chart to
                // refresh itself using the new data.
                self.model.data = self.toggle ? self.pieData1 : self.pieData2
            }
        }
    }
}

struct PieChartTab_Previews: PreviewProvider {
    static var previews: some View {
        PieChartTab()
    }
}
