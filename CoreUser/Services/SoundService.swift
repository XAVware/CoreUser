//
//  Sound.swift
//  CoreUser
//
//  Created by Ryan Smetana on 1/21/25.
//

import AVFoundation
import SwiftUI

@MainActor
final class SoundService {
    static let shared = SoundService()
    private init() { }
    
    private var audioPlayers: [SoundEffect: AVAudioPlayer] = [:]
    
    enum SoundEffect: String, CaseIterable {
        case buttonTap = "boing-pop"
    }
    
    func playSound(_ effect: SoundEffect) {
        if let player = audioPlayers[effect] {
            player.currentTime = 0
            player.play()
        } else {
            if let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "wav") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    audioPlayers[effect] = player
                    player.prepareToPlay()
                    player.play()
                } catch {
                    print("Error loading sound effect: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Preloads all sound effects into memory
    func preloadSounds() {
        SoundEffect.allCases.forEach { effect in
            if let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    audioPlayers[effect] = player
                    player.prepareToPlay()
                } catch {
                    print("Error preloading sound: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Releases all cached audio players to free up memory
    func cleanup() {
        audioPlayers.removeAll()
    }
}
