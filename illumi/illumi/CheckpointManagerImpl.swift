//
//  CheckpointManager.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation

class CheckpointManagerImpl: CheckpointManager{
    var delegate: CheckpointManagerDelegate?
    var checkpoints: [Checkpoint]{
        get{
            var checkpoints = [Checkpoint]()
            checkpoints.append(Checkpoint(cleared: true, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 1)))
            checkpoints.append(Checkpoint(cleared: false, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 2)))
            checkpoints.append(Checkpoint(cleared: true, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 3)))
            checkpoints.append(Checkpoint(cleared: false, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 2, minor: 4)))
            checkpoints.append(Checkpoint(cleared: true, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 2, minor: 5)))
            checkpoints.append(Checkpoint(cleared: false, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 2, minor: 6)))
            checkpoints.append(Checkpoint(cleared: true, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 3, minor: 7)))
            checkpoints.append(Checkpoint(cleared: false, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 3, minor: 8)))
            checkpoints.append(Checkpoint(cleared: true, identity: BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 3, minor: 9)))
            return checkpoints
        }
    }
}

extension CheckpointManagerImpl: BeaconManagerDelegate{
    func beaconManager(didCalculateNearestBeacon beacon: CLBeacon) {
        if(beacon.proximity == CLProximity.Immediate){
            // Call authentication manager
        }
    }
    
    func beaconManager(didRangeBeacons beacons: [CLBeacon]) {
        /*var checkpoints: [Checkpoint] = []
        for beacon in beacons{
            checkpoints.append(Checkpoint(cleared: true, identity: beacon.beaconIdentity()))
        }
        
        delegate?.checkpointManager(didUpdateOrderOfCheckpoints: checkpoints)*/
    }
}