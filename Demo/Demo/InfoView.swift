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
        Text(loremIpsum)
    }
}

#Preview("Form") {
    Form {
        InfoView("Information Section", systemImage: "ellipsis.bubble.fill") {
            Text(loremIpsum)
        }
    }
    .formStyle(.grouped)
}
#endif
