# HUDKit

A macOS HUD (heads-up-display) alert library written in Swift.

## Note

To enable HUD notifications showing over top of full-screen application windows participating in Spaces, **one of two known methods** will work:

1. Activation Policy API

   - Early in application execution, ie: `func applicationDidFinishLaunching(_:)`

     ```swift
     NSApp.setActivationPolicy(.accessory)
     
     // Apple documentation:
     // "The application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be activated programmatically or by clicking on one of its windows. This corresponds to value of the LSUIElement key in the application’s Info.plist being 1."
     NSApplication.ActivationPolicy.accessory
     ```

2. Adding info.plist keys

   - Add the following keys are necessary to be present in your application's info.plist file, using 0 or 1 for presentation mode.

     ```xml
     <key>LSUIElement</key>
     <true/>
      
     <key>LSUIPresentationMode</key>
     <integer>0</integer>
     ```
