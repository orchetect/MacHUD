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
        
        let text: String
        let size: TextSize
        
        var body: some View {
            Text(text)
                .font(.system(size: textFontSize))
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .frame(maxWidth: Geometry.maxContentWidth)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

extension ProminentHUDStyle.ContentView.TextView {
    enum TextSize: String, CaseIterable, Sendable {
        case imageAndText
        case textOnly
    }
    
    private var textFontSize: CGFloat {
        switch size {
        case .imageAndText: textWithImageFontSize
        case .textOnly: textOnlyFontSize
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
    
    private var textColor: Color {
        .primary
    }
}

#endif
