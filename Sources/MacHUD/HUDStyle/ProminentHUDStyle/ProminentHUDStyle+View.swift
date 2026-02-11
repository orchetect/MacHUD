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
            VStack(spacing: 14) {
                switch content {
                case let .text(text):
                    TextView(text: text, isTextOnly: true)
                case let .image(imageSource):
                    ImageView(imageSource: imageSource, format: .imageOnly)
                case let .textAndImage(text: text, image: imageSource):
                    ImageView(imageSource: imageSource, format: .imageAndText)
                    TextView(text: text, isTextOnly: false)
                case let .imageAndProgress(image: imageSource, value: progressValue):
                    ImageView(imageSource: imageSource, format: .imageAndProgress)
                    AmountView(value: progressValue)
                }
            }
            .padding(Geometry.padding)
        }
    }
}

extension ProminentHUDStyle.ContentView {
    struct ImageView: View {
        @Environment(\.colorScheme) private var colorScheme
        private typealias Geometry = ProminentHUDStyle.Geometry
        
        let imageSource: HUDImageSource
        let format: ImageFormat
        
        var body: some View {
            switch format {
            case .imageAndText:
                conditionalImageView
                    .frame(width: Geometry.imageSize, height: Geometry.imageSize)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: true))
                    .padding([.top], 15) // based on Xcode 26.3's built-in HUD alerts
            
            case .imageAndProgress:
                conditionalImageView
                    .frame(width: Geometry.imageSize * 0.8, height: Geometry.imageSize * 0.8)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: false))
                    .padding([.top, .bottom], 14 * 2)
                
            case .imageOnly:
                conditionalImageView
                    .frame(width: Geometry.imageSize, height: Geometry.imageSize)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(
                        minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: false),
                        minHeight: Geometry.minSize(isImagePresent: true, isTextPresent: false)
                    )
            }
        }
        
        private var conditionalImageView: (some View)? {
            if #available(macOS 13.0, *) {
                return imageView?.fontWeight(.light)
            } else {
                return imageView
            }
        }
        
        private var imageView: (some View)? {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Geometry.imageColor(colorScheme: colorScheme))
                    .opacity(0.8)
            } else {
                nil
            }
        }
        
        enum ImageFormat: String, CaseIterable, Sendable {
            case imageAndText
            case imageAndProgress
            case imageOnly
        }
        
        private var image: Image? {
            imageSource.image
        }
    }
}

extension ProminentHUDStyle.ContentView {
    struct TextView: View {
        private typealias Geometry = ProminentHUDStyle.Geometry
        
        let text: String
        let isTextOnly: Bool
        
        var body: some View {
            Text(text)
                .font(.system(size: Geometry.textFontSize(isTextOnly: isTextOnly)))
                .foregroundColor(Geometry.textColor)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .frame(maxWidth: Geometry.maxContentWidth)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

// MARK: - Alert

extension ProminentHUDStyle {
    enum Geometry {
        static var alertScreenRect: NSRect? {
            try? NSScreen.alertScreen.effectiveAlertScreenRect
        }
        
        static let padding: CGFloat = 20.0
        
        static var maxContentWidth: CGFloat? {
            guard let alertScreenRect else { return nil }
            return alertScreenRect.width - (padding * 4)
        }
        
        static func minSize(isImagePresent: Bool, isTextPresent: Bool) -> CGFloat? {
            if isImagePresent, isTextPresent {
                imageSize * 1.45
            } else if isImagePresent {
                imageSize * 1.4
            } else {
                nil
            }
        }
    }
}

// MARK: - Text

extension ProminentHUDStyle.Geometry {
    static func textFontSize(isTextOnly: Bool) -> CGFloat {
        if isTextOnly {
            textOnlyFontSize
        } else {
            textWithImageFontSize
        }
    }
    
    static var textOnlyFontSize: CGFloat {
        let screenSize = alertScreenRect?.size
            ?? CGSize(width: 1920, height: 1080) // provide a reasonable default
        return textOnlyAlertFontSize(forScreenSize: screenSize)
    }
    
    static func textOnlyAlertFontSize(forScreenSize screenSize: CGSize) -> CGFloat {
        screenSize.width / 40
    }
    
    static var textWithImageFontSize: CGFloat {
        18.0
    }
    
    static var textColor: Color {
        .primary
    }
}

// MARK: - Image

extension ProminentHUDStyle.Geometry {
    static var imageSize: CGFloat { 110.0 } // based on Xcode 26.3's built-in HUD alerts
    
    static func imageColor(colorScheme: ColorScheme) -> Color {
        // .primary.opacity(0.8)
        
        switch colorScheme {
        case .light:
            return Color(#colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1))
        case .dark:
            return Color(#colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1))
        @unknown default:
            assertionFailure("Unhandled color scheme: \(colorScheme).")
            return Color(#colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1))
        }
    }
}

// MARK: - Xcode Previews

// TODO: add more previews once additional alert content parameters have been implemented

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
        content: .image(.systemName("speaker.wave.3.fill"))
    )
}

#Preview("Image & Text") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .textAndImage(text: "Volume", image: .systemName("speaker.wave.3.fill"))
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

#endif

#endif
