//
//  ChartControlBar.swift
//  SwiftUICharts
//
//  Created by Peter Ent on 9/14/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

struct ChartControlBar: View {
    @Binding var showGrid: Bool
    @Binding var showShadow: Bool
    
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button("Toggle Data") {
                withAnimation {
                    self.action()
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
        }
    }
}


struct ChartControlBar_Previews: PreviewProvider {
    static var previews: some View {
        ChartControlBar(showGrid: .constant(false), showShadow: .constant(false)) {
            // does nothing
        }
    }
}
