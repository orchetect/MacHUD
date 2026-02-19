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
            conditionalView
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 15)
                .frame(width: MenuPopoverHUDStyle.size.width /* , height: MenuPopoverHUDStyle.size.height */)
                .fixedSize()
        }
        
        @ViewBuilder
        private var conditionalView: some View {
            switch content {
            case let .text(title, subtitle: subtitle):
                TextView(title: title, subtitle: subtitle)
                
            case let .image(imageSource):
                ImageView(imageSource: imageSource, animationDelay: style.imageAnimationDelay)
                
            case let .imageAndText(image: imageSource, title: title, subtitle: subtitle):
                ImageAndTextView(imageSource: imageSource, title: title, subtitle: subtitle, animationDelay: style.imageAnimationDelay)
                
            case let .textAndProgress(title: title, subtitle: subtitle, value: value, progressImages: progressImages):
                TextAndProgressView(
                    imageSource: nil,
                    title: title,
                    subtitle: subtitle,
                    progressImages: progressImages,
                    progressValue: value,
                    animationDelay: style.imageAnimationDelay
                )
                
            case let .imageAndTextAndProgress(image: imageSource, title: title, subtitle: subtitle, value: value, progressImages: progressImages):
                TextAndProgressView(
                    imageSource: imageSource,
                    title: title,
                    subtitle: subtitle,
                    progressImages: progressImages,
                    progressValue: value,
                    animationDelay: style.imageAnimationDelay
                )
            }
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct TextView: View {
        let title: String
        let subtitle: String?
        
        var body: some View {
            VStack(spacing: 5) {
                HStack {
                    Text(title)
                        .font(.system(size: titleFontSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    Spacer()
                }
                
                if let subtitle, !subtitle.trimmed.isEmpty {
                    HStack {
                        Text(subtitle)
                            .font(.system(size: subtitleFontSize, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                        Spacer()
                    }
                }
            }
        }
        
        private let titleFontSize: CGFloat = 12.0
        
        private var subtitleFontSize: CGFloat {
            titleFontSize * 0.9
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct ImageView: View {
        let imageSource: HUDImageSource
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    image
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        @ViewBuilder
        private var image: (some View)? {
            if let view = imageSource.view(animationDelay: animationDelay) {
                view
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct ImageAndTextView: View {
        let imageSource: HUDImageSource
        let title: String
        let subtitle: String?
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    if let image {
                        image
                            .frame(width: 24, height: 24)
                    }
                    
                    TextView(title: title, subtitle: subtitle)
                }
            }
        }
        
        private var image: (some View)? {
            imageSource.view(animationDelay: animationDelay)
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct TextAndProgressView: View {
        let imageSource: HUDImageSource?
        let title: String
        let subtitle: String?
        let progressImages: HUDProgressImageSource?
        let progressValue: HUDSteppedProgressValue
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                if let imageSource {
                    ImageAndTextView(imageSource: imageSource, title: title, subtitle: subtitle, animationDelay: animationDelay)
                } else {
                    TextView(title: title, subtitle: subtitle)
                }
                
                HStack {
                    if let minImage {
                        minImage
                            .frame(height: 12)
                    }
                    
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
                    
                    AmountView(value: progressUnitInterval, dividerCount: dividerCount)
                    
                    if let maxImage {
                        maxImage
                            .frame(height: 12)
                    }
                }
                .foregroundStyle(.primary)
                .frame(minHeight: 16)
            }
        }
        
        private var minImage: (some View)? {
            if let progressImages {
                switch progressImages {
                case let .minMax(min: minSource, max: _):
                    minSource.scalableImage
                }
            } else {
                nil
            }
        }
        
        private var maxImage: (some View)? {
            if let progressImages {
                switch progressImages {
                case let .minMax(min: _, max: maxSource):
                    maxSource.scalableImage
                }
            } else {
                nil
            }
        }
        
        private var progressUnitInterval: CGFloat {
            progressValue.unitInterval
        }
        
        private var dividerCount: Int? {
            guard let segmentCount = progressValue.step?.segmentCount(for: progressValue.range) else { return nil }
            let dividerCount = segmentCount - 1
            guard dividerCount > 1 else { return nil }
            return dividerCount
        }
    }
}

// MARK: - Xcode Previews

@available(macOS 26.0, *)
private struct MockHUDView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
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
#Preview("Text-Only") {
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
                content: .text("MacBook Pro Speakers", subtitle: "Volume: 70%")
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

@available(macOS 26.0, *)
#Preview("Image-Only") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .image(.static(.symbol(systemName: "speaker.3.fill")))
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

@available(macOS 26.0, *)
#Preview("Audio Volume") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .audioVolume(deviceName: "MacBook Pro Speakers", level: .unitInterval(0.0))
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .audioVolume(deviceName: "MacBook Pro Speakers", level: .unitInterval(1 / 18))
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .audioVolume(deviceName: "MacBook Pro Speakers", level: .unitInterval(5 / 18))
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .audioVolume(deviceName: "MacBook Pro Speakers", level: .unitInterval(8 / 18))
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .audioVolume(deviceName: "MacBook Pro Speakers", level: .unitInterval(17 / 18))
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .audioVolume(deviceName: "MacBook Pro Speakers", level: .unitInterval(1.0))
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

@available(macOS 26.0, *)
#Preview("Image & Text") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.symbol(systemName: "speaker.3.fill")), title: "MacBook Pro Speakers")
            )
        }
        
        MockHUDView {
            let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.nsImage(nsImage, desaturated: false)), title: #"Added "New Photo.jpg""#)
            )
        }
        
        MockHUDView {
            let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.nsImage(nsImage, desaturated: true)), title: #"Added "New Photo.jpg""#)
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

@available(macOS 26.0, *)
#Preview("Image & Text (Animated)") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
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
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
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
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

@available(macOS 26.0, *)
#Preview("Image & Text (with Subheading)") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.symbol(systemName: "speaker.3.fill")), title: "MacBook Pro Speakers")
            )
        }
        
        MockHUDView {
            let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.nsImage(nsImage, desaturated: false)), title: "Photos", subtitle: #"Added "New Photo.jpg""#)
            )
        }
        
        MockHUDView {
            let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.nsImage(nsImage, desaturated: true)), title: "Photos", subtitle: #"Added "New Photo.jpg""#)
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

@available(macOS 26.0, *)
#Preview("Image & Text & Progress") {
    VStack(spacing: 20) {
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndTextAndProgress(
                    image: .static(.symbol(systemName: "speaker.3.fill")),
                    title: "MacBook Pro Speakers",
                    subtitle: nil,
                    value: .unitInterval(0.6),
                    progressImages: nil
                )
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndTextAndProgress(
                    image: .static(.symbol(systemName: "speaker.3.fill")),
                    title: "MacBook Pro Speakers",
                    subtitle: "Volume: 60%",
                    value: .unitInterval(0.6),
                    progressImages: nil
                )
            )
        }
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

#endif

#endif
