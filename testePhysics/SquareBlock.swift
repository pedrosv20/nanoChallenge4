//
//  SquareBlock.swift
//  testePhysics
//
//  Created by Pedro Vargas on 05/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit

class SquareBlock: Block {    
    
    
    init(texture: String) {
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: -75, y: -50),
                                CGPoint(x: 75, y: -50),
                                CGPoint(x: 75, y: 50),
                                CGPoint(x: 25, y: 50),
                                CGPoint(x: 25, y: 0),
                                CGPoint(x: -75, y: 0)])
        path.closeSubpath()
        super.init(path: path, texture: texture)
    }
}
