//
//  Dev Tests.swift
//  HUDKit • https://github.com/orchetect/HUDKit
//

import Testing
@testable import HUDKit
import AppKit

@Test func showDefaultHUD() async {
    dump(NSScreen.screens)
    print(NSScreen.main?.localizedName as Any)
    
    try? await Task.sleep(nanoseconds: 1.secondsToNanoseconds)
    HUD.displayAlert("Test")
    try? await Task.sleep(nanoseconds: 4.secondsToNanoseconds)
    
    print("Done")
}

@Test func showLongFadeHUD() async {
    let style = HUD.Style(
        stickyTime: 1.0,
        position: .bottom,
        size: .large,
        shade: .dark,
        bordered: false,
        fadeOut: .withDuration(2.0)
    )
    
    try? await Task.sleep(nanoseconds: 1.secondsToNanoseconds)
    HUD.displayAlert("Test", style: style)
    try? await Task.sleep(nanoseconds: 4.secondsToNanoseconds)
    
    print("Done")
}
