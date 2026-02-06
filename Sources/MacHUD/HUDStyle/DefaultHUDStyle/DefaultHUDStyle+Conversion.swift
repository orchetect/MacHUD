//
//  DefaultHUDStyle+Conversion.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

extension DefaultHUDStyle {
    func convertedToProminentHUDStyle() -> ProminentHUDStyle {
        ProminentHUDStyle(
            transitionIn: transitionIn,
            duration: duration,
            transitionOut: transitionOut
        )
    }
    
    @available(macOS 26.0, *)
    func convertedToMenuPopoverHUDStyle() -> MenuPopoverHUDStyle {
        MenuPopoverHUDStyle(
            transitionIn: transitionIn,
            duration: duration,
            transitionOut: transitionOut
        )
    }
}

#endif
