//
//  MenuPopoverHUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
import SwiftUI

@available(macOS 26.0, *)
struct MenuPopoverHUDView: View {
    @Environment(ViewModel.self) private var viewModel
    
    let panel: ContentView.Panel = .menuPopover
    
    @State private var titleText = "Volume"
    @State private var subtitleText = ""
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
                
                Section("Generate HUD Alerts") {
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
                    
                    Picker("System Symbol", selection: $image) {
                        ForEach(SampleImage.allCases) { image in
                            Image(systemName: image.rawValue).tag(image)
                        }
                    }
                    
                    Toggle("Animate Symbol", isOn: $isImageAnimated)
                    
                    TextField("Title Text", text: $titleText)
                    
                    TextField("Subtitle Text", text: $subtitleText)
                    
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
                
                Section("Advanced Animation HUD Alerts") {
                    Button("Show Audio Unmute HUD Alert") {
                        showUnmuteAudioAlert()
                    }
                }
                
                Section("Debug / Testing") {
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
                
                Section("Memory Debug / Testing") {
                    LabeledContent("Count", value: "\(alertCount)")
                    
                    Toggle("Show Continuously (Stress Test)", isOn: $isContinuous)
                        .onChange(of: isContinuous) { oldValue, newValue in
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
                style: style.statusItem(viewModel.statusItem),
                content: .text(titleText, subtitle: subtitleText)
            )
        }
    }
    
    private func showImageOnlyAlert() {
        Task {
            let image: HUDImageSource = isImageAnimated
                ? .animated(.image(.systemName(image.rawValue), effect: .bounce, speedMultiplier: nil))
                : .static(.symbol(systemName: image.rawValue))
            await HUDManager.shared.displayAlert(
                style: style.statusItem(viewModel.statusItem),
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
                style: style.statusItem(viewModel.statusItem),
                content: .imageAndText(image: image, title: titleText, subtitle: subtitleText)
            )
        }
    }
    
    private func showAudioVolumeChangeAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(viewModel.statusItem),
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
                style: .menuPopover().statusItem(viewModel.statusItem),
                content: .screenBrightness(level: .value(Int.random(in: 0 ... 18), range: 0 ... 18))
            )
        }
    }
    
    private func showUnmuteAudioAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(viewModel.statusItem),
                content: .imageAndText(
                    image: .animated(.imageReplacement(
                        initial: .systemName("speaker.slash.fill", renderingMode: .hierarchical),
                        target: .systemName("speaker.wave.3.fill", renderingMode: .hierarchical),
                        magicReplace: false,
                        speedMultiplier: nil
                    )),
                    title: "Built-In Speakers"
                )
            )
        }
    }
    
    private func showShowTextOnlyAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(viewModel.statusItem),
                content: .text(loremIpsum)
            )
        }
    }
    
    private func showShowImageAndTextAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(viewModel.statusItem),
                content: .imageAndText(
                    image: .static(.symbol(systemName: "pencil.and.scribble")),
                    title: loremIpsum
                )
            )
        }
    }
    
    private func showShowImageAndProgressBarAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .menuPopover().statusItem(viewModel.statusItem),
                content: .textAndProgress(
                    title: loremIpsum,
                    progressValue: .unitInterval(.random(in: 0.0 ... 1.0)),
                    progressImages: .audioVolume
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
                    style: style.statusItem(viewModel.statusItem),
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
