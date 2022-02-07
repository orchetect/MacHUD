# HUDKit

A macOS HUD (heads-up-display) alert library written in Swift.

## Note

To enable HUD notifications showing over top of full-screen application windows partifipating in Spaces, the following keys are necessary to be present in your application's info.plist file:

<key>LSUIElement</key>
<true/>

<key>LSUIPresentationMode</key>
<integer>0</integer>
