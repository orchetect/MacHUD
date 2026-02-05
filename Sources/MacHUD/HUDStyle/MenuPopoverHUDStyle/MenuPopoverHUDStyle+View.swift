//
//  MenuPopoverHUDStyle+View.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle {
    public struct ContentView: View, HUDView {
        let content: HUDAlertContent
        let style: MenuPopoverHUDStyle
        
        public init(content: HUDAlertContent, style: MenuPopoverHUDStyle) {
            self.content = content
            self.style = style
        }
        
        public var body: some View {
            VStack(spacing: 10) {
                if let text {
                    HStack {
                        Text(text)
                            .font(.system(size: 12, weight: .semibold))
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                        Spacer()
                    }
                }
                
                HStack {
                    Image(systemName: "speaker.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                    
                    // ProgressView(value: 0.6, total: 1.0, label: { Text("") })
                    //     .progressViewStyle(.linear)
                    
                    // Slider(value: .constant(0.6), in: 0.0 ... 1.0, step: 0.05) { Text("") }
                    //     .sliderThumbVisibility(.hidden)
                    //     .controlSize(.small)
                    //     .labelsHidden()
                    //     .allowsHitTesting(false)
                    
                    AmountView(amount: 0.6, step: 0.1)
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                }
                .foregroundStyle(.primary)
                .frame(minHeight: 16)
            }
            .padding([.top, .bottom], 12)
            .padding([.leading, .trailing], 15)
            .frame(width: MenuPopoverHUDStyle.size.width /* , height: MenuPopoverHUDStyle.size.height */)
        }
        
        private var text: String? {
            switch content {
            case let .text(text),
                 let .textAndImage(text: text, image: _):
                text
            case let .image(imageSource):
                nil
            }
        }
        
        private var image: Image? {
            switch content {
            case .text(_): nil
            case let .image(imageSource),
                 let .textAndImage(text: _, image: imageSource):
                switch imageSource {
                case let .systemName(systemName): Image(systemName: systemName)
                case let .image(image): image
                }
            }
        }
        
        struct AmountView<Value: BinaryFloatingPoint>: View {
            @Environment(\.controlSize) private var controlSize
            
            let amount: Value
            let range: ClosedRange<Value>
            let step: Value?
            
            @State private var width: CGFloat = 0
            
            init(amount: Value, range: ClosedRange<Value> = 0.0 ... 1.0, step: Value? = nil) {
                self.amount = amount
                self.range = range
                self.step = step
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
                            ForEach(0 ..< dividerCount) { _ in
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
            
            private var dividerCount: Int? {
                guard let step else { return nil }
                let safeStep = step.clamped(to: 0.0...)
                guard safeStep > 0.0 else { return nil }
                let count = (Int((range.upperBound - range.lowerBound) / safeStep) - 1)
                    .clamped(to: 2 ... 100)
                return count
            }
        }
    }
}

// MARK: - Xcode Previews

@available(macOS 26.0, *)
private struct MockHUDView<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        ZStack {
            HUDWindowContext.GlassView(cornerRadius: MenuPopoverHUDStyle.cornerRadius)
                .frame(width: MenuPopoverHUDStyle.size.width)
            
            content()
        }
    }
}

#if DEBUG
@available(macOS 26.0, *)
#Preview("Example") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                content: .text("MacBook Pro Speakers"),
                style: .default()
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                content: .image(.systemName("square.fill")),
                style: .default()
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

#endif

#endif
