//
//  HUDManager Alert ContentView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Combine
import SwiftUI
internal import SwiftExtensions

extension HUDManager.Alert {
    struct ContentView: View {
        let content: HUDManager.AlertContent?
        let style: HUDStyle
        
        init(content: HUDManager.AlertContent? = nil, style: HUDStyle = .currentPlatform) {
            self.content = content
            self.style = style
        }
        
        var body: some View {
            InnerContentView(content: content, style: style)
                .padding(20)
                .allowsHitTesting(false)
        }
    }
}

extension HUDManager.Alert {
    struct InnerContentView: View {
        let text: String?
        let imageSource: HUDManager.AlertContent.ImageSource?
        let style: HUDStyle
        
        init(text: String? = nil, imageSource: HUDManager.AlertContent.ImageSource? = nil, style: HUDStyle = .currentPlatform) {
            self.text = text
            self.imageSource = imageSource
            self.style = style
        }
        
        init(content: HUDManager.AlertContent?, style: HUDStyle = .currentPlatform) {
            if let content {
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
            } else {
                text = nil
                imageSource = nil
            }
            
            self.style = style
        }
        
        var body: some View {
            VStack(spacing: 20) {
                if let conditionalImageView, let textView {
                    conditionalImageView
                    textView
                } else if let conditionalImageView {
                    conditionalImageView
                } else if let textView {
                    textView
                } else {
                    // force the view to have content in case both image and text are nil
                    Text(verbatim: " ")
                }
            }
            .aspectRatio(isImagePresent ? 1.0 : nil, contentMode: .fit)
            .frame(minWidth: minSize, minHeight: minSize)
        }
        
        @ViewBuilder
        private var conditionalImageView: (some View)? {
            if #available(macOS 13.0, *) {
                imageView?.fontWeight(.light)
            } else {
                imageView
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
            if let text, text != "" {
                Text(text)
                    .font(.system(size: textFontSize))
                    .foregroundColor(textColor)
                    .truncationMode(.tail)
            } else {
                nil
            }
        }
        
        private var image: Image? {
            guard let imageSource else { return nil }
            
            switch imageSource {
            case let .systemName(systemName):
                if #available(macOS 11, *) {
                    return Image(systemName: systemName)
                } else {
                    // TODO: needs implementation on macOS 10.15
                    return nil
                }
            case let .image(image):
                return image
            }
        }
        
        private var isTextPresent: Bool {
            text != nil
        }
        
        private var isImagePresent: Bool {
            imageSource != nil
        }
    }
}

extension HUDManager.Alert.InnerContentView {
    private var textFontSize: CGFloat {
        if image == nil {
            textOnlyFontSize
        } else {
            textWithImageFontSize
        }
    }
    
    private var textOnlyFontSize: CGFloat {
        HUDManager.Alert.textOnlyAlertFontSize()
    }
    
    private var textWithImageFontSize: CGFloat {
        20.0
    }
    
    private var textColor: Color {
        .primary
    }
}

extension HUDManager.Alert.InnerContentView {
    private var imageSize: CGFloat {
        switch style.size {
        case .small: 80.0
        case .medium: 100.0
        case .large: 120.0
        case .extraLarge: 150.0
        }
    }
    
    private var imageColor: Color {
        // .primary.opacity(0.8)
        
        switch style.tint {
        case .light, .mediumLight: Color(#colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1))
        case .dark, .ultraDark: Color(#colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1))
        }
    }
}

extension HUDManager.Alert.InnerContentView {
    private var minSize: CGFloat? {
        if isImagePresent, isTextPresent {
            imageSize * 1.35
        } else if isImagePresent {
            imageSize * 1.3
        } else {
            nil
        }
    }
}

#if DEBUG
#Preview("Text") {
    HUDManager.Alert.ContentView(content: .text("Test"))
}

#Preview("Text (Long)") {
    HUDManager.Alert.ContentView(content: .text("This is a very long test of a text-only HUD message."))
}

#Preview("Image (Large) (Default)") {
    HUDManager.Alert.ContentView(content: .image(.systemName("speaker.wave.3.fill")))
}

#Preview("Image (Small)") {
    HUDManager.Alert.ContentView(
        content: .image(.systemName("speaker.wave.3.fill")),
        style: .currentPlatform.size(.small)
    )
}

#Preview("Image (Medium)") {
    HUDManager.Alert.ContentView(
        content: .image(.systemName("speaker.wave.3.fill")),
        style: .currentPlatform.size(.medium)
    )
}

#Preview("Image (Extra Large)") {
    HUDManager.Alert.ContentView(
        content: .image(.systemName("speaker.wave.3.fill")),
        style: .currentPlatform.size(.extraLarge)
    )
}

#Preview("Text & Image (Large) (Default)") {
    HUDManager.Alert.ContentView(content: .textAndImage(text: "Volume", image: .systemName("speaker.wave.3.fill")))
}

#Preview("Text & Image (Small)") {
    HUDManager.Alert.ContentView(
        content: .textAndImage(text: "Volume", image: .systemName("speaker.wave.3.fill")),
        style: .currentPlatform.size(.small)
    )
}

#Preview("Text & Image (Medium)") {
    HUDManager.Alert.ContentView(
        content: .textAndImage(text: "Volume", image: .systemName("speaker.wave.3.fill")),
        style: .currentPlatform.size(.medium)
    )
}

#Preview("Text & Image (Extra Large)") {
    HUDManager.Alert.ContentView(
        content: .textAndImage(text: "Volume", image: .systemName("speaker.wave.3.fill")),
        style: .currentPlatform.size(.extraLarge)
    )
}
#endif

#endif
