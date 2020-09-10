//
//  View+If.swift
//  Animations
//
//  Created by Peter Ent on 9/9/20.
//  Copyright © 2020 Peter Ent. All rights reserved.
//

import SwiftUI

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}
