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
        let pathConverted = getPath(path: path)
        let block = Block(path: pathConverted, texture: texture, type: path)
        
        return block
    }
    
    private func getPath(path: BlockType) -> CGMutablePath {
        switch path {
            case .Bar:
                return PathHelper.shared.pathArray[0]
            case .Square:
                return PathHelper.shared.pathArray[1]
            case .Teco:
                return PathHelper.shared.pathArray[2]
            case .Tareco:
                return PathHelper.shared.pathArray[3]

        }
    }
    
    
    
}

/*
 
 let node = BlockBuilder(texture : "1", path: "tareco")
 node.paths
 
 */

//por que lemos wtf como fala e lol nao
