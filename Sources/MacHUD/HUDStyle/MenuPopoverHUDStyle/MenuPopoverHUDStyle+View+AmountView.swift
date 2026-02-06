//
//  MenuPopoverHUDStyle+View.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct AmountView<Value: BinaryFloatingPoint>: View {
        @Environment(\.controlSize) private var controlSize
        
        let amount: Value
        let range: ClosedRange<Value>
        let step: Value?
        let dividerCount: Int?
        
        @State private var width: CGFloat = 0
        
        init(amount: Value, range: ClosedRange<Value> = 0.0 ... 1.0, step: Value? = nil) {
            self.amount = amount
            self.range = range
            self.step = step
            dividerCount = Self.dividerCount(range: range, step: step)
        }
        
        public var body: some View {
            ZStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.quaternary)
                        .onGeometryChange(for: CGFloat.self, of: { $0.size.width }) { width = $0 }
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.primary)
                        .frame(width: progressWidth)
                }
                .offset(y: dividerCount != nil ? -1 : 0)
                
                if let dividerCount {
                    HStack {
                        ForEach(0 ..< dividerCount, id: \.self) { _ in
                            Circle()
                                .fill(.quaternary)
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(width: width)
                    .offset(y: height)
                }
            }
            .frame(height: height)
        }
        
        private var height: CGFloat {
            switch controlSize {
            case .mini: 2
            case .small: 3
            case .regular: 4
            case .large: 5
            case .extraLarge: 6
            @unknown default: 4
            }
        }
        
        private var progressWidth: CGFloat {
            width * percentage
        }
        
        private var percentage: CGFloat {
            let safeAmount = amount.clamped(to: range)
            
            // avoid division by zero
            guard range.upperBound > range.lowerBound else { return 1.0 }
            
            return CGFloat((safeAmount - range.lowerBound) / (range.upperBound - range.lowerBound))
        }
        
        private static func dividerCount(range: ClosedRange<Value>, step: Value?) -> Int? {
            guard let step else { return nil }
            let safeStep = step.clamped(to: 0.0...)
            guard safeStep > 0.0 else { return nil }
            let count = (Int((range.upperBound - range.lowerBound) / safeStep) - 1)
                .clamped(to: 2 ... 100)
            return count
        }
    }
}

#endif
