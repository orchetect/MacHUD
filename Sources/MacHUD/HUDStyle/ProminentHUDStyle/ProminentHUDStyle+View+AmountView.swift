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
        
        let progressValue: HUDSteppedProgressValue
        let segmentCount: Int?
        
        typealias Geometry = ProminentHUDStyle.Geometry
        
        /// - Parameters:
        ///   - value: Progress value.
        ///   - segmentCount: Number of segments that the progress bar is divided into.
        ///     macOS 11 thru 15 HUD used 16 segments for audio volume and screen brightness.
        ///     If `nil`, the progress bar is rendered as segmentless.
        init(value: HUDSteppedProgressValue) {
            self.progressValue = value
            
            let proposedSegmentCount: Int? = if let step = value.step {
                switch step {
                case let .span(double):
                    step.segmentCount(for: value.range)
                case let .segmentCount(count):
                    count
                }
            } else { nil }
            
            if let proposedSegmentCount, proposedSegmentCount < 1 {
                self.segmentCount = nil
            } else {
                self.segmentCount = proposedSegmentCount?.clamped(to: 0 ... 100)
            }
        }
        
        var body: some View {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Geometry.backColor)
                
                conditionalBody
                    .offset(x: 1)
            }
            .frame(width: Geometry.width, height: Geometry.segmentHeight + 2)
            .fixedSize()
        }
        
        @ViewBuilder
        private var conditionalBody: some View {
            if let segmentCount {
                SegmentedBarView(progressValue: progressValue.value, segmentCount: segmentCount)
            } else {
                ContinuousBarView(progressValue: progressValue.value)
            }
        }
    }
}

extension ProminentHUDStyle.ContentView.AmountView {
    struct SegmentedBarView: View {
        let progressValue: HUDProgressValue
        let segmentCount: Int
        
        typealias Geometry = ProminentHUDStyle.Geometry
        
        var body: some View {
            HStack(spacing: 1.0) {
                ForEach(0 ..< segmentCount, id: \.self) { index in
                    Rectangle()
                        .fill(isSegmentFilled(index: index) ? Geometry.foreColor : .clear)
                        .padding([.top, .bottom], 1.0)
                }
            }
        }
        
        private func isSegmentFilled(index: Int) -> Bool {
            Double(index) < (progressValue.unitInterval * Double(segmentCount))
        }
    }
    
    struct ContinuousBarView: View {
        let progressValue: HUDProgressValue
        
        typealias Geometry = ProminentHUDStyle.Geometry
        
        var body: some View {
            ZStack(alignment: .leading) {
                Color.clear
                
                Rectangle()
                    .fill(Geometry.foreColor)
                    .frame(width: (Geometry.width - 2) * progressValue.unitInterval)
                    .padding([.top, .bottom], 1.0)
            }
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
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: .segmentCount(0)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: .segmentCount(0)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: .segmentCount(0)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: .segmentCount(0)))
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: .segmentCount(1)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: .segmentCount(1)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: .segmentCount(1)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: .segmentCount(1)))
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: .segmentCount(2)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: .segmentCount(2)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: .segmentCount(2)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: .segmentCount(2)))
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: .segmentCount(10)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: .segmentCount(10)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: .segmentCount(10)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: .segmentCount(10)))
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: .segmentCount(20)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: .segmentCount(20)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: .segmentCount(20)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: .segmentCount(20)))
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: .segmentCount(100)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: .segmentCount(100)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: .segmentCount(100)))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: .segmentCount(100)))
        
        Divider()
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.0, step: nil))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.2, step: nil))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(0.5, step: nil))
        ProminentHUDStyle.ContentView.AmountView(value: .unitInterval(1.0, step: nil))
    }
    .padding(20)
}
#endif

#endif
