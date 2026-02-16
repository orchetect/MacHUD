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
            case let .text(text):
                TextView(text: text)
            case let .image(imageSource):
                ImageView(imageSource: imageSource, animationDelay: style.imageAnimationDelay)
            case let .imageAndText(image: imageSource, text: text):
                ImageAndTextView(imageSource: imageSource, text: text, animationDelay: style.imageAnimationDelay)
            case let .textAndProgress(text: text, value: value, images: imageSources):
                TextAndProgressView(text: text, progressImages: imageSources, progressValue: value)
            }
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct TextView: View {
        let text: String
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    Text(text)
                        .font(.system(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    Spacer()
                }
            }
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
        let text: String
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    if let image {
                        image
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(text)
                        .font(.system(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    Spacer()
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
        let text: String
        let progressImages: HUDProgressImageSource?
        let progressValue: HUDSteppedProgressValue
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    Text(text)
                        .font(.system(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    Spacer()
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
                content: .image(.static(.symbol(systemName: "speaker.3.fill")))
            )
        }
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.symbol(systemName: "speaker.3.fill")), text: "MacBook Pro Speakers")
            )
        }
        
        MockHUDView {
            let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.nsImage(nsImage, desaturated: false)), text: #"Added "New Photo.jpg""#)
            )
        }
        
        MockHUDView {
            let nsImage = NSWorkspace.shared.icon(forFile: "/System/Applications/Photos.app")
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .imageAndText(image: .static(.nsImage(nsImage, desaturated: true)), text: #"Added "New Photo.jpg""#)
            )
        }
            
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
                content: .textAndProgress(text: "System Audio", value: .unitInterval(0.1), images: .audioVolume)
            )
        }
        
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
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
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
        
        MockHUDView {
            MenuPopoverHUDStyle.ContentView(
                style: .init(),
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
        
        Spacer()
            .layoutPriority(1)
    }
    .padding()
}

#endif

#endif
