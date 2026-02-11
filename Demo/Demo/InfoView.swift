//
//  InfoView.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct InfoView<Content: View>: View {
    let title: String
    let systemImage: String
    let hasBackground: Bool
    @ViewBuilder let content: () -> Content
    
    init(_ title: String, systemImage: String, hasBackground: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.hasBackground = hasBackground
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if hasBackground {
                Color(NSColor.quaternaryLabelColor)
                    .clipShape(.rect(cornerRadius: 20.0))
            } else {
                Color.clear
            }
                
            VStack(spacing: 15) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.accentColor)
                
                Text(title)
                    .font(.largeTitle)
                
                content()
                    .multilineTextAlignment(.leading)
            }
            .foregroundStyle(.primary)
            .padding(30)
        }
        .ignoresSafeArea()
    }
}

#if DEBUG
#Preview {
    InfoView("Information Section", systemImage: "ellipsis.bubble.fill") {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    }
}

#Preview("Form") {
    Form {
        InfoView("Information Section", systemImage: "ellipsis.bubble.fill") {
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        }
    }
    .formStyle(.grouped)
}
#endif
