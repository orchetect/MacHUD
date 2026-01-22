//
//  ContentView.swift
//  swift-hud • https://github.com/orchetect/swift-hud
//

import SwiftUI
import SwiftHUD

struct ContentView: View {
    @State private var text = "Volume"
    @State private var image: SampleImage = .speakerVolumeHigh
    @State private var style: HUDStyle = .currentPlatform
    
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
            }
            .formStyle(.grouped)
        }
        .padding()
    }
}
