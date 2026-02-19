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
                
            case let .textAndProgress(
                title: title,
                subtitle: subtitle,
                progressValue: progressValue,
                progressImages: progressImages
            ):
                TextAndProgressView(
                    imageSource: nil,
                    title: title,
                    subtitle: subtitle,
                    progressImages: progressImages,
                    progressValue: progressValue,
                    animationDelay: style.imageAnimationDelay
                )
                
            case let .imageAndTextAndProgress(
                image: imageSource,
                title: title,
                subtitle: subtitle,
                progressValue: progressValue,
                progressImages: progressImages
            ):
                TextAndProgressView(
                    imageSource: imageSource,
                    title: title,
                    subtitle: subtitle,
                    progressImages: progressImages,
                    progressValue: progressValue,
                    animationDelay: style.imageAnimationDelay
                )
            }
        }
    }
}

// MARK: - Xcode Previews

#if DEBUG

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
                    progressValue: .unitInterval(0.6),
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
                    progressValue: .unitInterval(0.6),
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
