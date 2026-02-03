# MacHUD

A macOS HUD (heads-up-display) alert library written in Swift.

This package simulates macOS system HUD alerts.

> [!NOTE]
>
> Currently the style of HUD found in macOS 11 through 15 is emulated. The macOS 26 'notification' HUD style is not yet implemented but may be added in a future release.

## Note

To enable HUD notifications showing over top of full-screen application windows participating in Spaces, **one of two known methods** will work:

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

## Usage

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/MacHUD` as the URL.

To add this package to a Swift package, add the dependency to your package and target in Package.swift:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/orchetect/MacHUD", from: "0.3.0")
    ],
    targets: [
        .target(
            dependencies: [
                "MacHUD"
            ]
        )
    ]
)
```

## Legacy

This repository was formerly known as HUDKit, and OTHUD prior to that.
