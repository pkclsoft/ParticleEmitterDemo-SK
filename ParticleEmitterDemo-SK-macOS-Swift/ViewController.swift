//
//  ViewController.swift
//  ParticleEmitterDemo-SK-macOS-Swift
//
//  Created by Peter Easdown on 4/8/21.
//  Copyright © 2021 71Squared Ltd. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            view.showsFPS = true
            view.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            view.ignoresSiblingOrder = true

            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: CGSize(width: 320, height: 568))
                //SKScene(fileNamed: "GameScene")
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)
        }
    }
}

