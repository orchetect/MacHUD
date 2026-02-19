//
//  ProminentHUDStyle+View+TextView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

extension ProminentHUDStyle.ContentView {
    struct TextView: View {
        private typealias Geometry = ProminentHUDStyle.Geometry
        
        let title: String
        let subtitle: String?
        let size: TextSize
        
        var body: some View {
            VStack(spacing: verticalSpacing) {
                Text(title)
                    .font(.system(size: titleFontSize))
                    .multilineTextAlignment(.center)
                    .truncationMode(.tail)
                    .lineSpacing(5.0)
                    .foregroundColor(titleTextColor)
                    .frame(maxWidth: Geometry.maxContentWidth)
                    .fixedSize(horizontal: true, vertical: false)
                
                if let subtitle, !subtitle.trimmed.isEmpty {
                    Text(subtitle)
                        .font(.system(size: subtitleFontSize))
                        .multilineTextAlignment(.center)
                        .truncationMode(.tail)
                        .lineSpacing(5.0)
                        .foregroundColor(subtitleTextColor)
                        .frame(maxWidth: Geometry.maxContentWidth)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
    }
}

extension ProminentHUDStyle.ContentView.TextView {
    enum TextSize: String, CaseIterable, Sendable {
        case imageAndText
        case textOnly
    }
    
    private var titleFontSize: CGFloat {
        switch size {
        case .imageAndText: textWithImageFontSize
        case .textOnly: textOnlyFontSize
        }
    }
    
    private var subtitleFontSize: CGFloat {
        switch size {
        case .imageAndText: titleFontSize * 0.75
        case .textOnly: titleFontSize * 0.4
        }
    }
    
    private var textOnlyFontSize: CGFloat {
        let screenSize = Geometry.alertScreenRect?.size
            ?? CGSize(width: 1920, height: 1080) // provide a reasonable default
        return textOnlyAlertFontSize(forScreenSize: screenSize)
    }
    
    private func textOnlyAlertFontSize(forScreenSize screenSize: CGSize) -> CGFloat {
        screenSize.width / 40
    }
    
    private var textWithImageFontSize: CGFloat {
        18.0
    }
    
    private var titleTextColor: Color {
        .primary
    }
    
    private var subtitleTextColor: Color {
        titleTextColor.opacity(0.8)
    }
    
    private var verticalSpacing: CGFloat {
        switch size {
        case .imageAndText: 5.0
        case .textOnly: 10.0
        }
    }
}

#endif
