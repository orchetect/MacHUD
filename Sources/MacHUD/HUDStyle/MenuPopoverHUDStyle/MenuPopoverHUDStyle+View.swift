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
        public typealias Style = MenuPopoverHUDStyle
        let style: Style
        let content: Style.AlertContent
        
        public init(style: Style, content: Style.AlertContent) {
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
                    
                    // Unfortunately, ProgressView and Slider have native behavior that makes their infill bar
                    // fade to a lighter color due to the fact that our HUD windows are not technically "in focus".
                    // This means we have to design our own custom 'progress view' to make up for that shortfall.
                    
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
            case .image(_):
                nil
            }
        }
        
        private var image: Image? {
            switch content {
            case .text(_): nil
            case let .image(imageSource),
                 let .textAndImage(text: _, image: imageSource):
                imageSource.image
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
#Preview("Examples") { // TODO: add more previews once additional alert content parameters have been implemented
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .text("MacBook Pro Speakers")
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .image(.systemName("square.fill"))
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

#endif

#endif
