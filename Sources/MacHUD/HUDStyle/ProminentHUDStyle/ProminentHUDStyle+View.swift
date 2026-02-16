//
//  ProminentHUDStyle+View.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension ProminentHUDStyle {
    public struct ContentView: View, HUDView {
        @Environment(\.colorScheme) private var colorScheme
        
        public typealias Style = ProminentHUDStyle
        let style: Style
        let content: Style.AlertContent
        
        public init(style: Style, content: Style.AlertContent) {
            self.style = style
            self.content = content
        }
        
        public var body: some View {
            conditionalBody
                .padding(Geometry.padding)
        }
        
        @ViewBuilder
        public var conditionalBody: some View {
            switch content {
            case let .text(text):
                TextView(text: text, size: .textOnly)
                
            case let .image(imageSource):
                ImageView(imageSource: imageSource, format: .imageOnly, animationDelay: nil)
                
            case let .imageAndText(image: imageSource, text: text):
                VStack(spacing: 14) {
                    ImageView(imageSource: imageSource, format: .imageAndText, animationDelay: nil)
                    TextView(text: text, size: .imageAndText)
                }
                
            case let .imageAndProgress(image: imageSource, value: progressValue):
                VStack(spacing: 14) {
                    ImageView(imageSource: imageSource, format: .imageAndProgress, animationDelay: nil)
                    AmountView(value: progressValue)
                }
            }
        }
    }
}

// MARK: - Xcode Previews

#if DEBUG
#Preview("Text") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .text("Test")
    )
}

#Preview("Text (Long)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .text("This is a very long test of a text-only HUD message.")
    )
}

#Preview("Image") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .image(.static(.symbol(systemName: "speaker.wave.3.fill")))
    )
}

#Preview("Image & Text") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndText(image: .static(.symbol(systemName: "speaker.wave.3.fill")), text: "Volume")
    )
}

#Preview("Image & Text (Animated)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndText(
            image: .animated(.image(
                .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
                effect: .bounce,
                speedMultiplier: nil
            )),
            text: "Volume"
        )
    )
}

#Preview("Image & Text (Transition)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndText(
            image: .animated(.imageReplacement(
                initial: .systemName("speaker.slash.fill", variable: 0.5, renderingMode: .hierarchical),
                target: .systemName("speaker.wave.3.fill", variable: 0.5, renderingMode: .hierarchical),
                speedMultiplier: 0.5
            )),
            text: "Built-In Speakers"
        )
    )
}

#Preview("Image & Progress (Volume)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .audioVolume(level: .unitInterval(0.6))
    )
}

#Preview("Image & Progress (Brightness)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .screenBrightness(level: .unitInterval(0.6))
    )
}

#Preview("Image & Progress (Non-Segmented)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndProgress(
            image: .static(.symbol(systemName: "speaker.wave.3.fill")),
            value: .value(0.3, range: 0.0 ... 1.0, step: .segmentCount(10))
        )
    )
}

#endif

#endif
