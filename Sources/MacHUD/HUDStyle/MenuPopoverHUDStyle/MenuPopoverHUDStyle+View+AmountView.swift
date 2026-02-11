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
        
        let value: Value
        let dividerCount: Int?
        
        @State private var width: CGFloat = 0
        
        init(value: Value, dividerCount: Int? = nil) {
            self.value = value
            
            if let dividerCount, dividerCount > 0 {
                self.dividerCount = dividerCount.clamped(to: 1 ... 30)
            } else {
                self.dividerCount = nil
            }
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
                        ForEach(0 ..< dividerCount, id: \.self) { index in
                            Circle()
                                .fill(.quaternary)
                                .frame(height: 2)
                            if index < dividerCount - 1 {
                                Spacer()
                            }
                        }
                    }
                    .frame(width: dividersWidth)
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
            width * CGFloat(value).clamped(to: 0.0 ... 1.0)
        }
        
        private var segmentsCount: Int? {
            guard let dividerCount, dividerCount >= 0 else { return nil }
            return dividerCount + 1
        }
        
        private var dividersWidth: CGFloat {
            guard width > 0.0 else { return 0.0 }
            return width - (segmentWidth * 2)
        }
        
        private var segmentWidth: CGFloat {
            guard let segmentsCount else { return 0.0 }
            return width / CGFloat(segmentsCount)
        }
    }
}

#if DEBUG
@available(macOS 26.0, *)
private typealias AmountView = MenuPopoverHUDStyle.ContentView.AmountView

@available(macOS 26.0, *)
#Preview {
    VStack(spacing: 20) {
        Text("No Dividers")
        
        AmountView(value: 0.0, dividerCount: nil)
        AmountView(value: 0.5, dividerCount: nil)
        AmountView(value: 1.0, dividerCount: nil)
        
        Text("Typical Dividers")
        
        AmountView(value: 0.0, dividerCount: 9)
        AmountView(value: 0.1, dividerCount: 9)
        AmountView(value: 0.2, dividerCount: 9)
        AmountView(value: 0.3, dividerCount: 9)
        AmountView(value: 0.4, dividerCount: 9)
        AmountView(value: 0.5, dividerCount: 9)
        AmountView(value: 0.6, dividerCount: 9)
        AmountView(value: 0.7, dividerCount: 9)
        AmountView(value: 0.8, dividerCount: 9)
        AmountView(value: 0.9, dividerCount: 9)
        AmountView(value: 1.0, dividerCount: 9)
        
        Text("Edge Case Dividers")
        
        AmountView(value: 0.5, dividerCount: -1)
        AmountView(value: 0.5, dividerCount: 0)
        AmountView(value: 0.5, dividerCount: 1)
        AmountView(value: 0.5, dividerCount: 2)
        AmountView(value: 0.5, dividerCount: 100)
        
        Text("System Volume and Display Brightness")
        
        AmountView(value: 1.0 / 18.0, dividerCount: 17)
        AmountView(value: 4.0 / 18.0, dividerCount: 17)
        AmountView(value: 9.0 / 18.0, dividerCount: 17)
        AmountView(value: 16.0 / 18.0, dividerCount: 17)
        AmountView(value: 17.0 / 18.0, dividerCount: 17)
    }
    .padding()
    .frame(width: 400)
    .fixedSize()
}
#endif

#endif
