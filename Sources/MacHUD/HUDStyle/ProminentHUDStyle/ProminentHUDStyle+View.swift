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
            case let .text(title, subtitle: subtitle):
                TextView(title: title, subtitle: subtitle, size: .textOnly)
                
            case let .image(imageSource):
                ImageView(imageSource: imageSource, format: .imageOnly, animationDelay: nil)
                
            case let .imageAndText(image: imageSource, title: title, subtitle: subtitle):
                VStack(spacing: 14) {
                    ImageView(imageSource: imageSource, format: .imageAndText, animationDelay: nil)
                    TextView(title: title, subtitle: subtitle, size: .imageAndText)
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
import AppKit

#Preview("Text") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .text("Test")
    )
}

#Preview("Text (Single Field Multi-line)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .text("Test Title\nTest Subtitle")
    )
}

#Preview("Text (Title & Subtitle)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .text("Test Title", subtitle: "Test Subtitle")
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

#Preview("Image (Color)") {
    let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .image(.static(.nsImage(nsImage, desaturated: false)))
    )
}

#Preview("Image (Desaturated)") {
    let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .image(.static(.nsImage(nsImage, desaturated: true)))
    )
}

#Preview("Image & Text") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndText(
            image: .static(.symbol(systemName: "speaker.wave.3.fill")),
            title: "Volume"
        )
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
            title: "Volume"
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
            title: "Built-In Speakers"
        )
    )
}

#Preview("Image & Text (Single Field Multi-line)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndText(
            image: .static(.symbol(systemName: "speaker.wave.3.fill")),
            title: "Volume\nBuilt-In Speakers"
        )
    )
}

#Preview("Image & Text (Title & Subtitle)") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .imageAndText(
            image: .static(.symbol(systemName: "speaker.wave.3.fill")),
            title: "Volume",
            subtitle: "Built-In Speakers"
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
