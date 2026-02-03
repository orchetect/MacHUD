//
//  SampleImage.swift
//  MacHUD • https://github.com/orchetect/MacHUD
//  © 2018-2026 Steffan Andrews • Licensed under MIT License
//

enum SampleImage: String {
    case speakerMute = "speaker.slash.fill" // 🔇
    case speakerVolumeLow = "speaker.wave.1.fill" // 🔈
    case speakerVolumeMedium = "speaker.wave.2.fill" // 🔉
    case speakerVolumeHigh = "speaker.wave.3.fill" // 🔊
}

extension SampleImage: CaseIterable { }

extension SampleImage: Identifiable {
    var id: String {
        rawValue
    }
}

extension SampleImage: Sendable { }
