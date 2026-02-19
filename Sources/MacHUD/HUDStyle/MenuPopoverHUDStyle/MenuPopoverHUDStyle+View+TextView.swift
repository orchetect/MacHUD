//
//  MenuPopoverHUDStyle+View+TextView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct TextView: View {
        let title: String
        let subtitle: String?
        
        var body: some View {
            VStack(spacing: 5) {
                HStack {
                    Text(title)
                        .font(.system(size: titleFontSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    Spacer()
                }
                
                if let subtitle, !subtitle.trimmed.isEmpty {
                    HStack {
                        Text(subtitle)
                            .font(.system(size: subtitleFontSize, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                        Spacer()
                    }
                }
            }
        }
        
        private let titleFontSize: CGFloat = 12.0
        
        private var subtitleFontSize: CGFloat {
            titleFontSize * 0.9
        }
    }
}

#endif
