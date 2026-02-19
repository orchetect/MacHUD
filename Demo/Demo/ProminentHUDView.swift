//
//  ProminentHUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
import SwiftUI

struct ProminentHUDView: View {
    let panel: ContentView.Panel = .prominent
    
    @State private var titleText = "Volume"
    @State private var subtitleText = ""
    @State private var image: SampleImage = .speakerVolumeHigh
    @State private var isImageAnimated: Bool = false
    @State private var style: ProminentHUDStyle = .init()
    
    @State private var isContinuous: Bool = false
    @State private var continuousTask: Task<Void, any Error>?
    @State private var alertCount: Int = 0
    
    var body: some View {
        VStack {
            Form {
                InfoView(panel.verboseName, systemImage: panel.systemImage) {
                    Text("HUD alerts used in macOS 11 through 15 (and earlier).")
                        .font(.headline)
                    
                    Text(
                        """
                        These alerts are presented as medium-sized temporary screen overlays centered in the lower half of the screen.
                        """
                    )
                }
                
                Section("Generate HUD Alerts") {
                    Picker("Position on Screen", selection: $style.position) {
                        ForEach(ProminentHUDStyle.Position.allCases) { position in
                            Text(position.name).tag(position)
                        }
                    }
                    
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
                    
                    Toggle("Animate Image", isOn: $isImageAnimated)
                    
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
                    Button("Show Xcode Build HUD Alert") {
                        showXcodeBuildAlert()
                    }
                    
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

extension ProminentHUDView {
    private func showTextOnlyAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: style,
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
                style: style,
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
                style: style,
                content: .imageAndText(image: image, title: titleText, subtitle: subtitleText)
            )
        }
    }
    
    private func showXcodeBuildAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .prominent(),
                content: .imageAndText(image: .static(.image(Image(.xcodeBuild))), title: "Build Succeeded")
            )
        }
    }
    
    private func showAudioVolumeChangeAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .prominent(),
                content: .audioVolume(level: .unitInterval(.random(in: 0.0 ... 1.0)))
            )
        }
    }
    
    private func showScreenBrightnessChangeAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .prominent(),
                content: .screenBrightness(level: .unitInterval(.random(in: 0.0 ... 1.0)))
            )
        }
    }
    
    private func showUnmuteAudioAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .prominent(),
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
                style: .prominent(),
                content: .text(loremIpsum)
            )
        }
    }
    
    private func showShowImageAndTextAlertWithVeryLongText() {
        Task {
            await HUDManager.shared.displayAlert(
                style: .prominent(),
                content: .imageAndText(
                    image: .static(.symbol(systemName: "pencil.and.scribble")),
                    title: loremIpsum
                )
            )
        }
    }
}

extension ProminentHUDView {
    private func startContinuousTask() {
        stopContinuousTask()
        
        continuousTask = Task {
            while !Task.isCancelled {
                await HUDManager.shared.displayAlert(style: style, content: .text(UUID().uuidString))
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
