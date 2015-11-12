//
//  Checkpoint.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

class Checkpoint{
    let dateFormatter: NSDateFormatter
    
    var identity: BeaconIdentity
    var cleared: Bool{
        didSet{
            if(cleared == true){
                timeStampWhenCleared = NSDate()
            }
        }
    }
    var timeStampWhenCleared: NSDate?
    
    init(cleared: Bool, identity: BeaconIdentity){
        self.cleared = cleared
        self.identity = identity
        self.dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("jjmmss")
    }
    
    convenience init(identity: BeaconIdentity){
        self.init(cleared: false, identity: identity)
    }
    
    func timeStampWhenCheckpointWasClearedAsString()->String{
        guard let timeStamp = timeStampWhenCleared else{
            return ""
        }
        return dateFormatter.stringFromDate(timeStamp)
    }
    
    func asString() -> String{
        return "Major: \(identity.major), minor: \(identity.minor)"
    }
}