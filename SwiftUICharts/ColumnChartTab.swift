//
//  ColumnChartTab.swift
//  SwiftUICharts
//
//  Created by Peter Ent on 9/14/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

struct ColumnChartTab: View {
    
    // Create the ChartModel used in the sample. These are temperature
    // values (°F) so their range is set with the model (the default would be
    // the min and max from the data itself).
    @State private var model = ChartModel(dataRange: -32...100)
    
    @State private var toggle = true
    @State private var showGrid = false
    @State private var showShadow = false
    
    // Data used with the ChartModel. This app toggles between these two
    // data sets.
    let temps1: [Double] = [82.4, 55.6, -14.4, 11.25, -16.75, 56.4]
    let temps2: [Double] = [39.5, 99.2, 0, 32.3, 47.8, 87.24]
    
    // initialize this view with the first data set
    init() {
        self.model.data = self.temps1
    }
    
    // mostly uses defaults, supplying grid and shadow via state (default is
    // false for both).
    var body: some View {
        VStack {
            ColumnChartView(model: self.model,
                            showGrid: self.showGrid,
                            showShadow: self.showShadow)
            
            ChartControlBar(showGrid: self.$showGrid, showShadow: self.$showShadow) {
                self.toggle.toggle()
                
                // switch the model in the data which will trigger the chart to
                // refresh itself using the new data.
                self.model.data = self.toggle ? self.temps1 : self.temps2
            }
        }
    }
}

struct ColumnChartTab_Previews: PreviewProvider {
    static var previews: some View {
        ColumnChartTab()
    }
}
