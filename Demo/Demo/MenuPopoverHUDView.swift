//
//  MenuPopoverHUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
import SwiftUI

@available(macOS 26.0, *)
struct MenuPopoverHUDView: View {
    @Environment(\.statusItem) private var statusItem
    
    let panel: ContentView.Panel = .menuPopover
    
    @State private var text = "Volume"
    @State private var image: SampleImage = .speakerVolumeHigh
    @State private var isImageAnimated: Bool = false
    @State private var style: MenuPopoverHUDStyle = .init()
    
    @State private var isContinuous: Bool = false
    @State private var continuousTask: Task<Void, any Error>?
    @State private var alertCount: Int = 0
    
    var body: some View {
        VStack {
            Form {
                InfoView(panel.verboseName, systemImage: panel.systemImage) {
                    Text("Introduced by Apple in macOS 26.")
                        .font(.headline)
                    
                    Text(
                        """
                        These alerts are paired with Control Center menus. \
                        If the alert's corresponding menubar item is visible in the menubar, the HUD alert with pop under the menubar item. \
                        If the menubar item is not visible or has not been added to the menubar by the user, the HUD alert will pop under the main Control Center menubar item.
                        
                        When the user has an app in full-screen mode, the HUD alert is presented at the center top of the screen instead.
                        """
                    )
                }
                
                Section("Style") {
                    Picker("Transition In", selection: $style.transitionIn) {
                        ForEach(HUDTransition.allCases) { transition in
                            Text(transition.name).tag(transition)
                        }
                        Text("None").tag(nil as HUDTransition?)
                    }
                    
                    Slider(value: $style.duration, in: 0.0 ... 3.0, step: 0.1) {
                        Text("Duration (\(style.duration.formatted(.number.precision(.fractionLength(1 ... 2)))) seconds)")
                    }
                    
                    Picker("Transition Out", selection: $style.transitionOut) {
                        ForEach(HUDTransition.allCases) { transition in
                            Text(transition.name).tag(transition)
                        }
                        Text("None").tag(nil as HUDTransition?)
                    }
                }
                
                Section("Generate HUD Alert") {
                    Picker("System Symbol", selection: $image) {
                        ForEach(SampleImage.allCases) { image in
                            Image(systemName: image.rawValue).tag(image)
                        }
                    }
                    
                    Toggle("Animate Image", isOn: $isImageAnimated)
                    
                    TextField("HUD Text", text: $text)
                    
                    HStack {
                        Button("Show Text-Only Alert") {
                            showTextOnlyAlert()
                        }
                        
                        Button("Show Image-Only Alert") {
                            showImageOnlyAlert()
                        }
                        
                        Button("Show Image & Text Alert") {
                            showImageAndTextAlert()
                        }
                    }
                }
                
                Section("Sample HUD Alerts") {
                    Button("Show Audio Volume Change HUD Alert") {
                        showAudioVolumeChangeAlert()
                    }
                    
                    Button("Show Screen Brightness Change HUD Alert") {
                        showScreenBrightnessChangeAlert()
                    }
                }
                
                Section("Debug & Edge Case Testing") {
                    Button("Show Text-Only HUD Alert With Very Long Text") {
                        showShowTextOnlyAlertWithVeryLongText()
                    }
                    
                    Button("Show Image & Text HUD Alert With Very Long Text") {
                        showShowImageAndTextAlertWithVeryLongText()
                    }
                    
                    Button("Show Text & Progress Bar HUD Alert With Very Long Text") {
                        showShowImageAndProgressBarAlertWithVeryLongText()
                    }
                }
                
                Section("Memory Use Debug: Generate HUD Alerts Automatically") {
                    LabeledContent("Count", value: "\(alertCount)")
                    
                    Toggle("Show Continuously (Stress Test)", isOn: $isContinuous)
                        .onChange(of: isContinuous) { newValue in
                            newValue ? startContinuousTask() : stopContinuousTask()
                        }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDView {
    private func showTextOnlyAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: style.statusItem(statusItem),
                content: .text(text)
            )
        }
    }
    
    private func showImageOnlyAlert() {
        Task {
            let image: HUDImageSource = isImageAnimated
                ? .animated(.image(.systemName(image.rawValue), effect: .bounce, speedMultiplier: nil))
                : .static(.symbol(systemName: image.rawValue))
            await HUDManager.shared.displayAlert(
                style: style.statusItem(statusItem),
                content: .image(image)
            )
        }
    }
    
    private func showImageAndTextAlert() {
        Task {
            let image: HUDImageSource = isImageAnimated
                ? .animated(.image(.systemName(image.rawValue), effect: .bounce, speedMultiplier: nil))
                : .static(.symbol(systemName: image.rawValue))
            await HUDManager.shared.displayAlert(
                style: style.statusItem(statusItem),
                content: .imageAndText(image: image, text: text)
            )
        }
    }
    
    private func showAudioVolumeChangeAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(statusItem),
                content: .audioVolume(
                    deviceName: "MacBook Pro Speakers",
                    level: .value(Int.random(in: 0 ... 18), range: 0 ... 18)
                )
            )
        }
    }
    
    private func showScreenBrightnessChangeAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(statusItem),
                content: .screenBrightness(level: .value(Int.random(in: 0 ... 18), range: 0 ... 18))
            )
        }
    }
    
    private func showShowTextOnlyAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(statusItem),
                content: .text(
                    """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt \
                    ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco \
                    laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in \
                    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat \
                    non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                    """
                )
            )
        }
    }
    
    private func showShowImageAndTextAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(statusItem),
                content: .imageAndText(
                    image: .static(.symbol(systemName: "pencil.and.scribble")),
                    text:
                        """
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt \
                        ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco \
                        laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in \
                        voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat \
                        non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        """
                )
            )
        }
    }
    
    private func showShowImageAndProgressBarAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(statusItem),
                content: .textAndProgress(
                    text:
                        """
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt \
                        ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco \
                        laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in \
                        voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat \
                        non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        """,
                    value: .unitInterval(.random(in: 0.0 ... 1.0)),
                    images: .audioVolume
                )
            )
        }
    }
}

@available(macOS 26.0, *)
extension MenuPopoverHUDView {
    private func startContinuousTask() {
        stopContinuousTask()
        
        continuousTask = Task {
            while !Task.isCancelled {
                await HUDManager.shared.displayAlert(
                    style: style.statusItem(statusItem),
                    content: .text(UUID().uuidString)
                )
                alertCount += 1
                try await Task.sleep(for: .milliseconds(500))
            }
        }
    }
    
    private func stopContinuousTask() {
        continuousTask?.cancel()
        continuousTask = nil
    }
}
