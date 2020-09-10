//
//  GraphPaperView.swift
//  Animations
//
//  Created by Peter Ent on 9/9/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

// Displays a lined background behind a graph
//
struct GraphPaperView: View {
    var numCells = 20
    var lineColor: Color
    
    var body: some View {
        GraphPaper(numCells: self.numCells)
            .stroke(self.lineColor, lineWidth: 0.5)
    }
}

struct GraphPaper: Shape {
    var numCells: Int
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let yspacing = rect.height / CGFloat(numCells)
            let xspacing = rect.width / CGFloat(numCells)
            
            // horizontal lines
            var ypos = rect.height
            
            for _ in 0...numCells {
                path.move(to: CGPoint(x: 0, y: ypos))
                path.addLine(to: CGPoint(x: rect.width, y: ypos))
                ypos -= yspacing
            }
            
            // vertical lines
            var xpos: CGFloat = 0
            for _ in 0...numCells {
                path.move(to: CGPoint(x: xpos, y: 0))
                path.addLine(to: CGPoint(x: xpos, y: rect.height))
                xpos += xspacing
            }
        }
    }
}

struct GraphPaperView_Previews: PreviewProvider {
    static var previews: some View {
        GraphPaperView(numCells: 20, lineColor: Color.gray)
    }
}
