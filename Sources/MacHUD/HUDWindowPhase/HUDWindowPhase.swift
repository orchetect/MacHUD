//
//  HUDWindowPhase.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

/// HUD alert window phases.
public enum HUDWindowPhase {
    /// Initial setup when the alert window is first created.
    ///
    /// This phase is not called every time an alert is displayed. Instead, it is only called when
    /// a new window is needed. Windows are cached and preserved for reuse with subsequent alerts.
    case windowCreation

    /// This phase is called every time an alert is displayed.
    ///
    /// Respond to this phase if there are specific window modifications that need to be made based on
    /// the HUD alert content.
    ///
    /// For general window modifications that are only required for the HUD style and do not need to be
    /// per formed each time an alert is displayed, these can be performed by responding to the
    /// `windowCreation` phase.
    case contentUpdate

    /// The HUD alert content has been updated and is about to appear on-screen.
    case willAppear

    /// The HUD alert has completed its transition in and is now statically displayed on-screen.
    /// (At this time, if any image animations are present in the alert, they will start.)
    case didAppear

    /// The HUD alert has completed its static display on-screen and is about to transition out.
    case willDismiss

    /// The HUD alert has completed its transition out and is now fully dismissed from the screen.
    case didDismiss
}

extension HUDWindowPhase: Equatable { }

extension HUDWindowPhase: Hashable { }

extension HUDWindowPhase: CaseIterable { }

extension HUDWindowPhase: Sendable { }

#endif
