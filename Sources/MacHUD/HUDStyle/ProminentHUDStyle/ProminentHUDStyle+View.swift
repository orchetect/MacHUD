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
        let text: String?
        let imageSource: HUDImageSource?
        
        let padding: CGFloat = 20.0
        
        public init(
            text: String? = nil,
            imageSource: HUDImageSource? = nil,
            style: ProminentHUDStyle
        ) {
            self.text = text
            self.imageSource = imageSource
            self.style = style
        }
        
        public init(style: Style, content: Style.AlertContent) {
            switch content {
            case let .text(string):
                text = string
                imageSource = nil
            case let .image(imageSource):
                text = nil
                self.imageSource = imageSource
            case let .textAndImage(text: string, image: imageSource):
                text = string
                self.imageSource = imageSource
            }
            
            self.style = style
        }
        
        public var body: some View {
            VStack(spacing: 14) {
                if let conditionalImageView, let textView {
                    conditionalImageView
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(minWidth: minSize)
                        .padding([.top], 15) // based on Xcode 26.3's built-in HUD alerts
                    textView
                } else if let conditionalImageView {
                    conditionalImageView
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(minWidth: minSize, minHeight: minSize)
                } else if let textView {
                    textView
                } else {
                    // force the view to have content in case both image and text are nil
                    Text(verbatim: " ")
                }
            }
            .padding(padding)
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
                    .frame(width: imageSize, height: imageSize)
                    .foregroundColor(imageColor)
                    .opacity(0.8)
            } else {
                nil
            }
        }
        
        private var textView: (some View)? {
            if let text, !text.trimmed.isEmpty {
                Text(text)
                    .font(.system(size: textFontSize))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .truncationMode(.tail)
                    .frame(maxWidth: maxContentWidth)
                    .fixedSize(horizontal: true, vertical: false)
            } else {
                nil
            }
        }
        
        private var image: Image? {
            imageSource?.image
        }
    }
}

// MARK: - Geometry

extension ProminentHUDStyle.ContentView {
    private var alertScreenRect: NSRect? {
        try? NSScreen.alertScreen.effectiveAlertScreenRect
    }
    
    private var maxContentWidth: CGFloat? {
        guard let alertScreenRect else { return nil }
        return alertScreenRect.width - (padding * 4)
    }
    
    private var minSize: CGFloat? {
        if isImagePresent, isTextPresent {
            imageSize * 1.45
        } else if isImagePresent {
            imageSize * 1.4
        } else {
            nil
        }
    }
}

// MARK: - Text

extension ProminentHUDStyle.ContentView {
    private var isTextPresent: Bool {
        text != nil
    }
    
    private var textFontSize: CGFloat {
        if image == nil {
            textOnlyFontSize
        } else {
            textWithImageFontSize
        }
    }
    
    private var textOnlyFontSize: CGFloat {
        let screenSize = alertScreenRect?.size
            ?? CGSize(width: 1920, height: 1080) // provide a reasonable default
        return textOnlyAlertFontSize(forScreenSize: screenSize)
    }
    
    private func textOnlyAlertFontSize(forScreenSize screenSize: CGSize) -> CGFloat {
        screenSize.width / 40
    }
    
    private var textWithImageFontSize: CGFloat {
        18.0
    }
    
    private var textColor: Color {
        .primary
    }
}

// MARK: - Image

extension ProminentHUDStyle.ContentView {
    private var isImagePresent: Bool {
        imageSource != nil
    }
    
    private var imageSize: CGFloat { 110.0 } // based on Xcode 26.3's built-in HUD alerts
    
    private var imageColor: Color {
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

#Preview("Text & Image") {
    ProminentHUDStyle.ContentView(
        style: .prominent(),
        content: .textAndImage(text: "Volume", image: .systemName("speaker.wave.3.fill"))
    )
}

#endif

#endif
