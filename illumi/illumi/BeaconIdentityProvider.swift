//
//  BeaconIdentityProvider.swift
//  illumi
//
//  Created by James Bampoe on 01/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

final class BeaconIdentityProvider {
    static let illumiUUID = "6440D3EA-2361-4DB9-BDC3-2388C795FB4C"
    static let illumiBeaconsIdentifier = "illumi beacons"
    static let entranceIdentifier = "entrance" // TODO: use tupel
    static let exitIdentifier = "exit" // TODO: use tupel
    
    static func entrance() -> BeaconIdentity{
        return BeaconIdentity(UUID: NSUUID(UUIDString: illumiUUID)!, major: 1, minor: 1)
    }
    static func exit() -> BeaconIdentity{
        return BeaconIdentity(UUID: NSUUID(UUIDString: illumiUUID)!, major: 3, minor: 9)
    }
}