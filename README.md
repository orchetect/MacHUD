# MacHUD

[![Platforms | macOS 10.15+](https://img.shields.io/badge/platforms-macOS%2010.15+-blue.svg?style=flat)](https://developer.apple.com/swift) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/MacHUD/blob/main/LICENSE)

A heads-up-display (HUD) library written in Swift that simulates macOS system HUD alerts, as well as custom alert designs.

## Overview

Apple does not provide a public API to display system HUD alerts (such as those that appear when adjusting the system volume or screen brightness). However, in very specific cases it may be appropriate for an application to display an alert of this style.

These type of on-screen alerts are useful for conveying sparse, concise status information that may not be appropriate for a Notification Center notification.

These alerts are ephemerally displayed only for a few seconds as feedback in direct response to a user action (such as global keyboard shortcut or other input event) that changes a system or application setting. As such, these alerts should only be used sparsely and only for the most crucial status updates. Visual noise and other content including text should be kept to a bare minimum.

## Getting Started

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/MacHUD` as the URL.

1. To add this package to a Swift package, add the dependency to your package and target in Package.swift:

   ```swift
   .package(url: "https://github.com/orchetect/MacHUD", from: "0.4.1")
   ```

2. Import the library:

   ```swift
   import MacHUD
   ```

3. Try the [Demo](Demo) example project to see the library in action.

## Note

To enable HUD alerts showing over top of full-screen application windows participating in Spaces, **one of two known methods** will work:

1. Activation Policy API

   - Early in application execution, ie: `func applicationDidFinishLaunching(_:)`

     ```swift
     NSApp.setActivationPolicy(.accessory)
     ```
     
     > Apple Documentation
     >
     > `NSApplication.ActivationPolicy.accessory`
     >
     > "The application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be activated programmatically or by clicking on one of its windows. This corresponds to value of the LSUIElement key in the application’s Info.plist being 1."

2. Adding Info.plist keys

   - Add the following keys are necessary to be present in your application's info.plist file, using 0 or 1 for presentation mode.

     ```xml
     <key>LSUIElement</key>
     <true/>
      
     <key>LSUIPresentationMode</key>
     <integer>0</integer>
     ```

## Customization

In addition to pre-defined system alert styles provided by the library, fully custom alert windows can also be designed by adopting the `HUDStyle` protocol.



See the included `ProminentHUDStyle` and `MenuPopoverHUDStyle` HUD styles for examples on how to implement a custom HUD style.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MacHUD/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using MacHUD and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/MacHUD/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/MacHUD/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/MacHUD/discussions) first prior to new submitting PRs for features or modifications is encouraged.
