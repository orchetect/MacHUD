//
//  ContentView.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import SwiftHUD
import SwiftUI

struct ContentView: View {
    @State private var text = "Volume"
    @State private var image: SampleImage = .speakerVolumeHigh
    @State private var style: HUDStyle = .currentPlatform
    
    @State private var isContinuous: Bool = false
    @State private var continuousTask: Task<Void, any Error>?
    @State private var notificationCount: Int = 0
    
    var body: some View {
        VStack {
            Form {
                Section("Style") {
                    Picker("Position on Screen", selection: $style.position) {
                        ForEach(HUDStyle.Position.allCases) { position in
                            Text(position.name).tag(position)
                        }
                    }
                    
                    Picker("Size", selection: $style.size) {
                        ForEach(HUDStyle.Size.allCases) { size in
                            Text(size.name).tag(size)
                        }
                    }
                    
                    Picker("Tint", selection: $style.tint) {
                        ForEach(HUDStyle.Tint.allCases) { tint in
                            Text(tint.name).tag(tint)
                        }
                    }
                    
                    Toggle("Bordered", isOn: $style.isBordered)
                    
                    Picker("Transition In", selection: $style.transitionIn) {
                        ForEach(HUDStyle.Transition.allCases) { transition in
                            Text(transition.name).tag(transition)
                        }
                    }
                    
                    Slider(value: $style.duration, in: 0.0 ... 3.0, step: 0.1) {
                        Text("Duration (\(style.duration.formatted(.number.precision(.fractionLength(1 ... 2)))) seconds)")
                    }
                    
                    Picker("Transition Out", selection: $style.transitionOut) {
                        ForEach(HUDStyle.Transition.allCases) { transition in
                            Text(transition.name).tag(transition)
                        }
                    }
                }
                
                Section("Generate HUD Alert") {
                    Picker("System Symbol", selection: $image) {
                        ForEach(SampleImage.allCases) { image in
                            Image(systemName: image.rawValue).tag(image)
                        }
                    }
                    
                    TextField("HUD Text", text: $text)
                    
                    Button("Show Text-Only Alert") {
                        HUDManager.shared.displayAlert(.text(text), style: style)
                    }
                    
                    Button("Show Image-Only Alert") {
                        HUDManager.shared.displayAlert(.image(systemName: image.rawValue), style: style)
                    }
                    
                    Button("Show Image & Text Alert") {
                        HUDManager.shared.displayAlert(.textAndImage(text, systemName: image.rawValue), style: style)
                    }
                }
                
                Section("Generate HUD Alerts Automatically") {
                    LabeledContent("Count", value: "\(notificationCount)")
                    
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
                HUDManager.shared.displayAlert(.text(UUID().uuidString), style: style)
                notificationCount += 1
                try await Task.sleep(for: .milliseconds(500))
            }
        }
    }
    
    private func stopContinuousTask() {
        continuousTask?.cancel()
        continuousTask = nil
    }
}
