//
//  ProminentHUDStyle+View+AmountView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension ProminentHUDStyle.ContentView {
    struct AmountView: View {
        @Environment(\.controlSize) private var controlSize
        
        let progressValue: HUDProgressValue
        let segmentCount: Int = 16 // macOS 11 thru 15 HUD used 16 segments
        
        init(value: HUDProgressValue) {
            self.progressValue = value
        }
        
        public var body: some View {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.black.opacity(0.8)) // TODO: make dynamic based on color scheme
                
                HStack(spacing: 1) {
                    ForEach(0 ..< 16, id: \.self) { index in
                        Rectangle()
                            .fill(isSegmentFilled(index: index) ? .white : .clear) // TODO: make dynamic based on color scheme
                            .frame(width: 9, height: 6)
                    }
                }
                .offset(x: 1)
            }
            .frame(width: 161, height: 6 + 2) // actual measurements of macOS HUD
            .fixedSize()
        }
        
        private func isSegmentFilled(index: Int) -> Bool {
            Double(index) < (progressValue.unitInterval * Double(segmentCount))
        }
    }
}

#if DEBUG
#Preview {
    VStack {
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0))
        
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2))
        
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5))
        
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0))
    }
    .padding(20)
}
#endif

#endif
