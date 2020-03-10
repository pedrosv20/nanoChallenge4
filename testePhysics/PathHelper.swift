//
//  PathHelper.swift
//  testePhysics
//
//  Created by Pedro Vargas on 05/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation
import SpriteKit

class PathHelper {
    
    static let shared = PathHelper()
    
    var pathArray: [CGMutablePath] = []
    let pathBar = CGMutablePath()

    let pathSquare = CGMutablePath()


    let pathTeco = CGMutablePath()


    let pathTareco = CGMutablePath()
    
    private init () {
        generatePaths()
    }
    
    func generatePaths() {

        pathBar.addLines(between: [CGPoint(x: 0, y: 0),
                                   CGPoint(x: 200, y: 0),
                                   CGPoint(x: 200, y: -50),
                                   CGPoint(x: 0, y: -50)])
        pathBar.closeSubpath()


        pathSquare.addLines(between: [CGPoint(x: 0, y: 0),
                                      CGPoint(x: 100, y: 0),
                                      CGPoint(x: 100, y: -100),
                                      CGPoint(x: 0, y: -100)])
        pathSquare.closeSubpath()


        pathTeco.addLines(between: [CGPoint(x: 2, y: -2),
                                      CGPoint(x: -98, y: -2),
                                      CGPoint(x: -98, y: -52),
                                      CGPoint(x: 148, y: -52),
                                      CGPoint(x: 148, y: -98),
                                      CGPoint(x: 50, y: -98),
                                      CGPoint(x: 50, y: -50),
                                      CGPoint(x: 0, y: -50), CGPoint(x: 0, y: 0)])
//        pathTeco.closeSubpath()


        pathTareco.addLines(between: [CGPoint(x: 0, y: 0),
                                      CGPoint(x: 50, y: 0),
                                      CGPoint(x: 50, y: -50),
                                      CGPoint(x: 150, y: -50),
                                      CGPoint(x: 150, y: -100),
                                      CGPoint(x: 0, y: -100),  CGPoint(x: 0, y: 0)])
//        pathTareco.closeSubpath()
        
        pathArray.append(pathBar)
        pathArray.append(pathSquare)
        pathArray.append(pathTeco)
        pathArray.append(pathTareco)
    }
}

