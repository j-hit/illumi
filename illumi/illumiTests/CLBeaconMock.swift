//
//  CLBeaconMock.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation
@testable import illumi

class CLBeaconMock: CLBeacon{
    required init?(coder aDecoder: NSCoder) {
        _proximityUUID = NSUUID()
        _major = 0
        _minor = 0
        super.init(coder: aDecoder)
    }
    
    override init() {
        _proximityUUID = NSUUID()
        _major = 0
        _minor = 0
        super.init()
    }
    
    init(proximityUUID: NSUUID, major: Int, minor: Int){
        _proximityUUID = proximityUUID
        _major = NSNumber(integer: major)
        _minor = NSNumber(integer: minor)
        super.init()
    }
    
    convenience init(major: Int, minor: Int){
        self.init(proximityUUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: major, minor: minor)
    }
    
    private var _proximityUUID: NSUUID
    override var proximityUUID: NSUUID{
        get{
            return _proximityUUID
        }
        set{
            _proximityUUID = newValue
        }
    }
    
    private var _major: NSNumber
    override var major: NSNumber{
        get{
            return _major
        }
        set{
            _major = newValue
        }
    }
    
    private var _minor: NSNumber
    override var minor: NSNumber{
        get{
            return _minor
        }
        set{
            _minor = newValue
        }
    }
}