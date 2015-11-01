//
//  BeaconID.swift
//  illumi
//
//  Created by James Bampoe on 01/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation

struct BeaconIdentifier {
    let UUID: NSUUID
    let major: Int32
    let minor: Int32
}

extension CLBeacon{
    func beaconIdentifier() -> BeaconIdentifier{
        return BeaconIdentifier(UUID: proximityUUID, major: major.intValue, minor: minor.intValue)
    }
}