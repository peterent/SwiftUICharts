//
//  AxisView.swift
//  Animations
//
//  Created by Peter Ent on 9/8/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

// Displays a simple X-Y axis pair with (0,0) in the lower left corner.
//
// If the charts are to display negative values, then one of the axis lines should be drawn through
// the zero point which may be anywhere. If that's the case, some more information needs to be
// passed to AxisView in order for it to determine where to draw the zero line.
//
struct AxisView: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines([CGPoint(x: 1, y: 1), CGPoint(x: 1, y: rect.height), CGPoint(x: rect.width, y: rect.height)])
        }
    }
}

struct AxisView_Previews: PreviewProvider {
    static var previews: some View {
        AxisView()
    }
}
