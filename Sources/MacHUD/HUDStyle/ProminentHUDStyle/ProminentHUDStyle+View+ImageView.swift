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
        
        var body: some View {
            switch format {
            case .imageAndText:
                framedImageView()
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: true))
                    .padding([.top], 15) // based on Xcode 26.3's built-in HUD alerts
            
            case .imageAndProgress:
                framedImageView(scale: 0.8)
                    .frame(minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: false))
                    .padding([.top, .bottom], 14 * 2)
                
            case .imageOnly:
                framedImageView()
                    .frame(
                        minWidth: Geometry.minSize(isImagePresent: true, isTextPresent: false),
                        minHeight: Geometry.minSize(isImagePresent: true, isTextPresent: false)
                    )
            }
        }
        
        private func framedImageView(scale: CGFloat = 1.0) -> some View {
            conditionalImageView
                .frame(width: Geometry.standardImageSize * scale, height: Geometry.standardImageSize * scale)
                .aspectRatio(1.0, contentMode: .fit)
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
                    .foregroundColor(imageColor)
                    .opacity(0.8)
            } else {
                nil
            }
        }
    }
}

extension ProminentHUDStyle.ContentView.ImageView {
    enum ImageFormat: String, CaseIterable, Sendable {
        case imageAndText
        case imageAndProgress
        case imageOnly
    }
    
    private var image: Image? {
        imageSource.image
    }
    
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

#endif
