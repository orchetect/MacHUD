//
//  CustomHUDView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import MacHUD
import SwiftUI

struct CustomHUDView: View {
    let panel: ContentView.Panel = .custom
    
    @State private var titleText = "Example Alert Text"
    @State private var style: MyHUDStyle = .init()
    
    var body: some View {
        VStack {
            Form {
                InfoView(panel.verboseName, systemImage: panel.systemImage) {
                    Text("Example custom HUD window style.")
                        .font(.headline)
                    
                    Text(
                        """
                        This example provides a very basic demonstration of how to adopt the `HUDStyle` protocol to create custom HUD window designs and behaviors.
                        
                        See the `MyHUDStyle.swift` file in this Demo project.
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
                    
                    TextField("Title Text", text: $titleText)
                    
                    Button("Show Alert") {
                        showAlert()
                    }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
    }
}

extension CustomHUDView {
    private func showAlert() {
        Task {
            await HUDManager.shared.displayAlert(
                style: style,
                content: .init(title: titleText)
            )
        }
    }
}
