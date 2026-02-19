//
//  MenuPopoverHUDStyle+View+ImageView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import SwiftUI

@available(macOS 26.0, *)
extension MenuPopoverHUDStyle.ContentView {
    struct ImageView: View {
        let imageSource: HUDImageSource
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    image
                        .frame(width: 24, height: 24)
                }
            }
        }
        
        @ViewBuilder
        private var image: (some View)? {
            if let view = imageSource.view(animationDelay: animationDelay) {
                view
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#endif
