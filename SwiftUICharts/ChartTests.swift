//
//  ChartTests.swift
//  Animations
//
//  Created by Peter Ent on 9/8/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

struct ChartTests: View {
    
    // Data used with the ChartModel. This app toggles between these two
    // data sets.
    let temps1: [Double] = [82.4, 55.6, -14.4, 11.25, -16.75, 56.4]
    let temps2: [Double] = [39.5, 99.2, 0, 32.3, 47.8, 87.24]
        
    @State private var toggle = true
    @State private var showGrid = false
    @State private var showShadow = false
    
    // Create the ChartModel used by both examples below. These are temperature
    // values (°F) so their range is set with the model (the default would be
    // the min and max from the data itself).
    @State private var model = ChartModel(dataRange: -32...100)
    
    var body: some View {
        VStack {
            Text("Chart Tests")
                .font(.title)
                .frame(height: 80)
            
            // mostly uses defaults, supplying grid and shadow via state (default is
            // false for both).
            ColumnChartView(model: self.model,
                            showGrid: self.showGrid,
                            showShadow: self.showShadow)
            
            Spacer()
            
            // shows how to supply a label formatter function for the elements in the
            // chart. First parameter is the value and second is its index
            // in the vector or data.
            BarChartView(model: self.model,
                         showGrid: self.showGrid,
                         showShadow: self.showShadow) { (_, index) in
                            String(format: "%.1f°F", self.model.data[index])
            }
            
            //
            // Some Controls
            //
            
            HStack {
                Button("Toggle Data") {
                    withAnimation {
                        self.toggle.toggle()
                        
                        // switch the model in the data which will trigger the chart to
                        // refresh itself using the new data.
                        self.model.data = self.toggle ? self.temps1 : self.temps2
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Displays Grid")
                        Toggle("", isOn: self.$showGrid).labelsHidden()
                    }
                    HStack {
                        Text("Displays Shadow")
                        Toggle("", isOn: self.$showShadow).labelsHidden()
                    }
                }
            }.padding()
        }
        .onAppear {
            self.model.data = self.temps1
        }
    }
}

struct ChartTests_Previews: PreviewProvider {
    static var previews: some View {
        ChartTests()
    }
}
