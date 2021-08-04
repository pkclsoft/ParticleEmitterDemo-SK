//
//  GameScene.swift
//  ParticleEmitterDemo-SK-Swift
//
//  Created by Peter Easdown on 27/3/21.
//  Copyright © 2021 71Squared Ltd. All rights reserved.
//

import SpriteKit
import GameplayKit
import SKParticleEmitter

class GameScene: SKScene {
    
    var particleEmitter : SKParticleEmitterNode?
    var particleEmitters = Array<SKParticleEmitterNode>()
    var particleEnumerator : EnumeratedSequence<[SKParticleEmitterNode]>.Iterator?
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // Create a list of emitter configs to load
        let configFiles = [
            "Comet",
            "Winner Stars",
            "Foam",
            "Blue Flame",
            "Atomic Bubble",
            "Crazy Blue",
            "Plasma Glow",
            "Meks Blood Spill",
            "Into The Blue",
            "JasonChoi_Flash",
            "Real Popcorn",
            "The Sun",
            "Touch Up",
            "Trippy",
            "Electrons",
            "Blue Galaxy",
            "huo1",
            "JasonChoi_rising up",
            "JasonChoi_Swirl01",
            "Shooting Fireball",
            "wu1"
        ]
        do {
            // Cycle through all emitters configs loading them
            try configFiles.forEach { (filename) in
                let emitter = try SKParticleEmitterNode(withConfigFile: filename, andTargetNode: self)
                
                // Center the particle system
                emitter.position = .zero
                self.particleEmitters.append(emitter)
            }
        } catch {
            
        }
        self.showNextEmitter()
    }
    
    var dragging : Bool = false
    var startPos : CGPoint = .zero
    
    #if os(macOS)
    var mouseDown : Bool = false
    
    override func mouseDown(with event: NSEvent) {
        startPos =  event.location(in: self)
        mouseDown = true
    }
    
    override func mouseUp(with event: NSEvent) {
        if !dragging {
            self.showNextEmitter()
        }
        
        dragging = false
        mouseDown = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        let newPosition = event.location(in: self)

        if (newPosition != startPos) && mouseDown {
            dragging = true
        }
        
        if dragging {
            particleEmitter?.emitter!.sourcePosition = Vector2(newPosition)
        }

    }
    #else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPos =  touches.first!.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPosition = touches.first!.location(in: self)

        if newPosition != startPos {
            dragging = true
        }
        
        if dragging {
            particleEmitter?.emitter!.sourcePosition = Vector2(newPosition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !dragging {
            self.showNextEmitter()
        }
        
        dragging = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    #endif
    
    /// 1/60th of a second.
    static let frameTime = TimeInterval(0.016)
    
    override func update(_ currentTime: TimeInterval) {
        self.particleEmitter?.update(withDelta: GameScene.frameTime, providingAlpha: 1.0)
    }
    
    func showNextEmitter() {
        if particleEmitter != nil {
            particleEmitter?.removeFromParent()
        }
        
        // If no enumerator exists or we've reached the last object in the enumerator, create a new enumerator
        if particleEnumerator == nil ||
            particleEmitter === particleEmitters.last {
            particleEnumerator = particleEmitters.enumerated().makeIterator()
        }
        
        // Get the next particle system from the enumerator and reset it
        particleEmitter = self.particleEnumerator?.next()?.element
        particleEmitter?.emitter!.reset()
        particleEmitter?.emitter!.sourcePosition = .zero
        self.addChild(particleEmitter!)
    }
    
}
