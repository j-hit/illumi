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
    var description: String
    var cleared: Bool{
        didSet{
            if(cleared == true){
                timeStampWhenCleared = NSDate()
            }
        }
    }
    var timeStampWhenCleared: NSDate?
    
    init(cleared: Bool, identity: BeaconIdentity, description: String){
        self.cleared = cleared
        self.identity = identity
        self.description = description
        self.dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("jjmmss")
    }
    
    convenience init(identity: BeaconIdentity){
        self.init(cleared: false, identity: identity, description: "")
    }
    
    convenience init(identity: BeaconIdentity, description: String){
        self.init(cleared: false, identity: identity, description: description)
    }
    
    func timeStampWhenCheckpointWasClearedAsString()->String{
        guard let timeStamp = timeStampWhenCleared else{
            return ""
        }
        return dateFormatter.stringFromDate(timeStamp)
    }
}