//
//  MenuPopoverHUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
import SwiftUI

@available(macOS 26.0, *)
struct MenuPopoverHUDView: View {
    @State private var text = "Volume"
    @State private var image: SampleImage = .speakerVolumeHigh
    @State private var prominentStyle: MenuPopoverHUDStyle = .init()
    
    @State private var isContinuous: Bool = false
    @State private var continuousTask: Task<Void, any Error>?
    @State private var alertCount: Int = 0
    
    var body: some View {
        VStack {
            Form {
                Section("Style") {
                    Picker("Transition In", selection: $prominentStyle.transitionIn) {
                        ForEach(HUDTransition.allCases) { transition in
                            Text(transition.name).tag(transition)
                        }
                    }
                    
                    Slider(value: $prominentStyle.duration, in: 0.0 ... 3.0, step: 0.1) {
                        Text("Duration (\(prominentStyle.duration.formatted(.number.precision(.fractionLength(1 ... 2)))) seconds)")
                    }
                    
                    Picker("Transition Out", selection: $prominentStyle.transitionOut) {
                        ForEach(HUDTransition.allCases) { transition in
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
                        HUDManager.shared.displayAlert(style: prominentStyle, content: .text(text))
                    }
                    
                    Button("Show Image-Only Alert") {
                        HUDManager.shared.displayAlert(
                            style: prominentStyle,
                            content: .image(.systemName(image.rawValue))
                        )
                    }
                    
                    Button("Show Image & Text Alert") {
                        HUDManager.shared.displayAlert(
                            style: prominentStyle,
                            content: .textAndImage(text: text, image: .systemName(image.rawValue))
                        )
                    }
                }
                
                Section("Generate HUD Alerts Automatically") {
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
                HUDManager.shared.displayAlert(style: prominentStyle, content: .text(UUID().uuidString))
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
