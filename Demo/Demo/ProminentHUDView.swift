//
//  ProminentHUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
import SwiftUI

struct ProminentHUDView: View {
    let panel: ContentView.Panel = .prominent
    
    @State private var text = "Volume"
    @State private var image: SampleImage = .speakerVolumeHigh
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
                
                Section("Style") {
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
                }
                
                Section("Generate HUD Alert") {
                    Picker("System Symbol", selection: $image) {
                        ForEach(SampleImage.allCases) { image in
                            Image(systemName: image.rawValue).tag(image)
                        }
                    }
                    
                    TextField("HUD Text", text: $text)
                    
                    HStack {
                        Button("Show Text-Only Alert") {
                            HUDManager.shared.displayAlert(style: style, content: .text(text))
                        }
                        
                        Button("Show Image-Only Alert") {
                            HUDManager.shared.displayAlert(
                                style: style,
                                content: .image(.systemName(image.rawValue))
                            )
                        }
                        
                        Button("Show Image & Text Alert") {
                            HUDManager.shared.displayAlert(
                                style: style,
                                content: .imageAndText(image: .systemName(image.rawValue), text: text)
                            )
                        }
                    }
                }
                
                Section("Sample HUD Alerts") {
                    Button("Show Xcode Build HUD Alert") {
                        HUDManager.shared.displayAlert(
                            style: .prominent(),
                            content: .imageAndText(image: .image(Image(.xcodeBuild)), text: "Build Succeeded")
                        )
                    }
                    
                    Button("Show Audio Volume Change HUD Alert") {
                        HUDManager.shared.displayAlert(
                            style: .prominent(),
                            content: .audioVolume(level: .unitInterval(.random(in: 0.0 ... 1.0)))
                        )
                    }
                    
                    Button("Show Screen Brightness Change HUD Alert") {
                        HUDManager.shared.displayAlert(
                            style: .prominent(),
                            content: .screenBrightness(level: .unitInterval(.random(in: 0.0 ... 1.0)))
                        )
                    }
                }
                
                Section("Debug & Edge Case Testing") {
                    Button("Show Text-Only HUD Alert With Very Long Text") {
                        HUDManager.shared.displayAlert(
                            style: .prominent(),
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
                    
                    Button("Show Image & Text HUD Alert With Very Long Text") {
                        HUDManager.shared.displayAlert(
                            style: .prominent(),
                            content: .imageAndText(
                                image: .systemName("pencil.and.scribble"),
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
    
    private func startContinuousTask() {
        stopContinuousTask()
        
        continuousTask = Task {
            while !Task.isCancelled {
                HUDManager.shared.displayAlert(style: style, content: .text(UUID().uuidString))
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
