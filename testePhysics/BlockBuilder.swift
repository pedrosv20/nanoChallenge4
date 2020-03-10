//
//  BlockBuilder.swift
//  testePhysics
//
//  Created by Pedro Vargas on 05/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit

class BlockBuilder {
    
    init() {}
    
    func createBlock(texture: String, path: BlockType) ->  Block {
        let texture = SKTexture(imageNamed: texture)
        let block = Block(texture: texture, type: path)
        
        return block
    }

}

//por que lemos wtf como fala e lol nao
