//
//  ChartTests.swift
//  Animations
//
//  Created by Peter Ent on 9/8/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

struct ChartTests: View {
        
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Charts").font(.title)
                Spacer()
            }.padding()
            
            TabView {
                BarChartTab()
                    .padding()
                    .tabItem {
                        VStack {
                            Image("BarTab")
                            Text("Bars")
                        }
                }.tag(0)
                
                ColumnChartTab()
                    .padding()
                    .tabItem {
                        VStack {
                            Image("ColumnTab")
                            Text("Columns")
                        }
                }.tag(1)
                
                LineChartTab()
                    .padding()
                    .tabItem {
                        VStack {
                            Image("LineTab")
                            Text("Lines")
                        }
                }.tag(2)
                
                PieChartTab()
                    .padding()
                    .tabItem {
                        VStack {
                            Image("PieTab")
                            Text("Pies")
                        }
                }.tag(3)
            }
        }
    }
}

struct ChartTests_Previews: PreviewProvider {
    static var previews: some View {
        ChartTests()
    }
}
