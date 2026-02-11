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
        }
        
        @ViewBuilder
        private var conditionalView: some View {
            switch content {
            case let .text(text):
                TextView(text: text)
            case let .image(imageSource):
                ImageView(imageSource: imageSource)
            case let .imageAndText(image: imageSource, text: text):
                ImageAndTextView(imageSource: imageSource, text: text)
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
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    (image ?? Image(systemName: "questionmark"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        private var image: Image? {
            imageSource.image
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct ImageAndTextView: View {
        let imageSource: HUDImageSource
        let text: String
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    if let image {
                        image
                            .resizable()
                            .scaledToFit()
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
        
        private var image: Image? {
            imageSource.image
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct TextAndProgressView: View {
        let text: String
        let progressImages: HUDProgressImageSource?
        let progressValue: HUDProgressValue
        
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
                            .resizable()
                            .scaledToFit()
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
                    
                    AmountView(amount: progressUnitInterval, step: 0.1)
                    
                    if let maxImage {
                        maxImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                    }
                }
                .foregroundStyle(.primary)
                .frame(minHeight: 16)
            }
        }
        
        private var minImage: Image? {
            guard let progressImages else { return nil }
            
            return switch progressImages {
            case let .minMax(min: minSource, max: _):
                minSource.image
            }
        }
        
        private var maxImage: Image? {
            guard let progressImages else { return nil }
            
            return switch progressImages {
            case let .minMax(min: _, max: maxSource):
                maxSource.image
            }
        }
        
        private var progressUnitInterval: CGFloat {
            progressValue.unitInterval
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
