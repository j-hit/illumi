//
//  BeaconIdentifierProvider.swift
//  illumi
//
//  Created by James Bampoe on 01/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

class BeaconIdentifierProvider {
    static let illumiUUID = "6440D3EA-2361-4DB9-BDC3-2388C795FB4C"
    static let illumiBeaconsIdentifier = "illumi beacons"
    
    static func entrance() -> BeaconIdentifier{
        return BeaconIdentifier(UUID: NSUUID(UUIDString: illumiUUID)!, major: 1, minor: 1)
    }
    static func exit() -> BeaconIdentifier{
        return BeaconIdentifier(UUID: NSUUID(UUIDString: illumiUUID)!, major: 3, minor: 9)
    }
}