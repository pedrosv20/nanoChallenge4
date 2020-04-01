//
//  AudioManager.swift
//  testePhysics
//
//  Created by José Guilherme Bestel on 17/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

//class AudioManager {
//
//    let lose :SKAction
//    let blockOut :SKAction
//    let blockTouch :SKAction
//    let newRecord :SKAction
//    let bg :SKAction
//
//    init(){
//        self.lose = SKAction.playSoundFileNamed("Lose.wav", waitForCompletion: true)
//        self.blockOut = SKAction.playSoundFileNamed("Block Out.wav", waitForCompletion: true)
//        self.blockTouch = SKAction.playSoundFileNamed("Block touch.wav", waitForCompletion: true)
//        self.newRecord = SKAction.playSoundFileNamed("New Record with crowd.wav", waitForCompletion: true)
//        self.bg = SKAction.repeatForever(SKAction.playSoundFileNamed("Towers Music.wav", waitForCompletion: true))
//    }
//}
import AVKit

class AudioPlayerImpl {
    
    private var currentMusicPlayer: AVAudioPlayer?
    private var currentEffectPlayer: AVAudioPlayer?
    var musicVolume: Float = 1.0 {
        didSet { currentMusicPlayer?.volume = musicVolume }
    }
    var effectsVolume: Float = 1.0
}

extension AudioPlayerImpl: AudioPlayer {
    
    func play(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.prepareToPlay()
        newPlayer.volume = musicVolume
        newPlayer.play()
        currentMusicPlayer = newPlayer
    }
    
    func pause(music: Music) {
        currentMusicPlayer?.pause()
    }
    
    func play(effect: Effect) {
        guard let effectPlayer = try? AVAudioPlayer(soundFile: effect) else { return }
        effectPlayer.volume = effectsVolume
        effectPlayer.play()
        currentEffectPlayer = effectPlayer
    }
}


struct Audio {
    
    struct MusicFiles {
        static let background = Music(filename: "Towers Music", type: "wav")
    }
    
    struct EffectFiles {
        static let blockOut = Effect(filename: "Block Out", type: "wav")
        static let blockTouch = Effect(filename: "Block touch", type: "wav")
        static let newRecord = Effect(filename: "New Record with crowd", type: "wav")
        static let lose = Effect(filename: "Lose", type: "wav")
    }
}

public protocol SoundFile {
    var filename: String { get }
    var type: String { get }
}

public struct Music: SoundFile {
    public var filename: String
    public var type: String
}

public struct Effect: SoundFile {
    public var filename: String
    public var type: String
}

protocol AudioPlayer {
    
    var musicVolume: Float { get set }
    func play(music: Music)
    func pause(music: Music)
    
    var effectsVolume: Float { get set }
    func play(effect: Effect)
}

extension AVAudioPlayer {
    
    public enum AudioPlayerError: Error {
        case fileNotFound
    }
    
    public convenience init(soundFile: SoundFile) throws {
        guard let url = Bundle.main.url(forResource: soundFile.filename, withExtension: soundFile.type) else { throw AudioPlayerError.fileNotFound }
        try self.init(contentsOf: url)
    }
}
