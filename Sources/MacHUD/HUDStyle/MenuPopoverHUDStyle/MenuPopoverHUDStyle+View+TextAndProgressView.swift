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
    struct TextAndProgressView: View {
        let imageSource: HUDImageSource?
        let title: String
        let subtitle: String?
        let progressImages: HUDProgressImageSource?
        let progressValue: HUDSteppedProgressValue
        let animationDelay: TimeInterval?
        
        var body: some View {
            VStack(spacing: 10) {
                if let imageSource {
                    ImageAndTextView(imageSource: imageSource, title: title, subtitle: subtitle, animationDelay: animationDelay)
                } else {
                    TextView(title: title, subtitle: subtitle)
                }
                
                HStack {
                    if let minImage {
                        minImage
                            .frame(height: 12)
                    }
                    
                    // Unfortunately, ProgressView and Slider have native behavior that makes their infill bar
                    // fade to a lighter color due to the fact that our HUD windows are not technically "in focus".
                    // This means we have to design our own custom 'progress view' to make up for that shortfall.
                    
                    // ProgressView(value: 0.6, total: 1.0, label: { Text("") })
                    //     .progressViewStyle(.linear)
                    
                    // Slider(value: .constant(0.6), in: 0.0 ... 1.0, step: 0.05) { Text("") }
                    //     .sliderThumbVisibility(.hidden)
                    //     .controlSize(.small)
                    //     .labelsHidden()
                    //     .allowsHitTesting(false)
                    
                    AmountView(value: progressUnitInterval, dividerCount: dividerCount)
                    
                    if let maxImage {
                        maxImage
                            .frame(height: 12)
                    }
                }
                .foregroundStyle(.primary)
                .frame(minHeight: 16)
            }
        }
        
        private var minImage: (some View)? {
            if let progressImages {
                switch progressImages {
                case let .minMax(min: minSource, max: _):
                    minSource.scalableImage
                }
            } else {
                nil
            }
        }
        
        private var maxImage: (some View)? {
            if let progressImages {
                switch progressImages {
                case let .minMax(min: _, max: maxSource):
                    maxSource.scalableImage
                }
            } else {
                nil
            }
        }
        
        private var progressUnitInterval: CGFloat {
            progressValue.unitInterval
        }
        
        private var dividerCount: Int? {
            guard let segmentCount = progressValue.step?.segmentCount(for: progressValue.range) else { return nil }
            let dividerCount = segmentCount - 1
            guard dividerCount > 1 else { return nil }
            return dividerCount
        }
    }
}

#endif
