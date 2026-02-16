//
//  DefaultHUDStyle+Conversion.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

extension DefaultHUDStyle {
    func convertedToProminentHUDStyle() -> ProminentHUDStyle {
        var style = ProminentHUDStyle()
            .transitionIn(transitionIn)
            .duration(duration)
            .transitionOut(transitionOut)
            // status item is not used
        
        if let imageAnimationDelay {
            style = style
                .imageAnimationDelay(imageAnimationDelay)
        }
        
        return style
    }
    
    @available(macOS 26.0, *)
    func convertedToMenuPopoverHUDStyle() -> MenuPopoverHUDStyle {
        var style = MenuPopoverHUDStyle()
            .transitionIn(transitionIn)
            .duration(duration)
            .transitionOut(transitionOut)
            .statusItem(statusItem)
        
        if let imageAnimationDelay {
            style = style
                .imageAnimationDelay(imageAnimationDelay)
        }
        
        return style
    }
}

#endif
