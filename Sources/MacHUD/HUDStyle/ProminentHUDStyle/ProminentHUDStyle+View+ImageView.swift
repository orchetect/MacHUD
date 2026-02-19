//
//  ProminentHUDStyle+View+ImageView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension ProminentHUDStyle.ContentView {
    struct ImageView: View {
        @Environment(\.colorScheme) private var colorScheme
        private typealias Geometry = ProminentHUDStyle.Geometry
        
        let imageSource: HUDImageSource
        let format: ImageFormat
        let animationDelay: TimeInterval?
        
        var body: some View {
            switch format {
            case .imageOnly:
                framedImageView()
                    .frame(
                        minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: false),
                        minHeight: Geometry.minSize(isImagePresent: true, isTextPresent: false)
                    )
                
            case .imageAndText:
                framedImageView()
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: true))
                    .padding([.top], 15) // based on Xcode 26.3's built-in HUD alerts
                
            case .imageAndProgress:
                framedImageView(scale: 0.8)
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: false))
                    .padding([.top, .bottom], 14 * 2)
                
            case .imageAndTextAndProgress:
                framedImageView()
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: true))
            }
        }
        
        private func framedImageView(scale: CGFloat = 1.0) -> some View {
            conditionalImageView
                .frame(width: Geometry.standardImageSize * scale, height: Geometry.standardImageSize * scale)
                .aspectRatio(1.0, contentMode: .fit)
        }
        
        private var conditionalImageView: (some View)? {
            if #available(macOS 13.0, *) {
                return imageView(animationDelay: animationDelay)?
                    .fontWeight(.light) // apply slight slender styling to system symbols
            } else {
                return imageView(animationDelay: animationDelay)
            }
        }
    }
}

extension ProminentHUDStyle.ContentView.ImageView {
    enum ImageFormat: String, CaseIterable, Sendable {
        case imageOnly
        case imageAndText
        case imageAndProgress
        case imageAndTextAndProgress
    }
    
    @ViewBuilder
    private func imageView(animationDelay: TimeInterval? = nil) -> (some View)? {
        switch imageSource {
        case let .static(staticSource):
            format(scalableImageView: staticSource.scalableImage)
        case let .animated(animatedSource):
            format(scalableImageView: animatedSource.view(animationDelay: animationDelay))
        }
    }
    
    /// Applies formatting to image. Assumes image is resizable and scaled-to-fit.
    private func format(scalableImageView view: (some View)?) -> (some View)? {
        view?
            .foregroundColor(imageColor)
            .opacity(0.9)
    }
    
    private var imageColor: Color {
        // .primary.opacity(0.8)
        
        switch colorScheme {
        case .light:
            if #available(macOS 26.0, *) {
                return .primary
            } else {
                return Color(#colorLiteral(red: 0.08749181937, green: 0.08749181937, blue: 0.08749181937, alpha: 1))
            }
        case .dark:
            return Color(#colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1))
        @unknown default:
            assertionFailure("Unhandled color scheme: \(colorScheme).")
            return .primary
        }
    }
}

#endif
