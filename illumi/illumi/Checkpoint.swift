//
//  Checkpoint.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

class Checkpoint{
    var cleared: Bool
    var identity: BeaconIdentity
    
    init(cleared: Bool, identity: BeaconIdentity){
        self.cleared = cleared
        self.identity = identity
    }
    
    convenience init(identity: BeaconIdentity){
        self.init(cleared: false, identity: identity)
    }
    
    func asString() -> String{
        return "Major: \(identity.major), minor: \(identity.minor)"
    }
}