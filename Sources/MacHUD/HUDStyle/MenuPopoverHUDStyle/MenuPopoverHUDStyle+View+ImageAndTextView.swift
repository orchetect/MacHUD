//
//  MenuPopoverHUDStyle+View+ImageAndTextView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct ImageAndTextView: View {
        let imageSource: HUDImageSource
        let title: String
        let subtitle: String?
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    if let image {
                        image
                            .frame(width: 24, height: 24)
                    }
                    
                    TextView(title: title, subtitle: subtitle)
                }
            }
        }
        
        private var image: (some View)? {
            imageSource.view(animationDelay: animationDelay)
        }
    }
}

#endif
