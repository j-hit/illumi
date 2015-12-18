//
//  BeaconID.swift
//  illumi
//
//  Created by James Bampoe on 01/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation

func ==(lhs: BeaconIdentity, rhs: BeaconIdentity) -> Bool{
    return lhs.UUID.isEqual(rhs.UUID) && lhs.major == rhs.major && lhs.minor == rhs.minor
}

struct BeaconIdentity: Equatable {
    let UUID: NSUUID
    let major: Int32
    let minor: Int32
    
    init(UUID: NSUUID, major: Int32, minor: Int32){
        self.UUID = UUID
        self.major = major
        self.minor = minor
    }
    
    init(major: Int32, minor: Int32){
        self.init(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: major, minor: minor)
    }
}

// MARK: - CLBeacon
extension CLBeacon{
    func beaconIdentity() -> BeaconIdentity{
        return BeaconIdentity(UUID: proximityUUID, major: major.intValue, minor: minor.intValue)
    }
}