//
//  File.swift
//  testePhysics
//
//  Created by Pedro Vargas on 13/03/20.
//  Copyright © 2020 Pedro Vargas. All rights reserved.
//

import Foundation

class UserInfo {
    
    var highScore = 0
    
    public static let shared = UserInfo()
    
    private init() {
        
    }
}
