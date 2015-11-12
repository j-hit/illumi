//
//  CheckpointManager.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation

final class CheckpointManagerImpl: CheckpointManager{
    var delegate: CheckpointManagerDelegate?
    var authenticationManager: AuthenticationManager
    
    lazy var checkpoints: [Checkpoint] = {
        var checkpointList = [Checkpoint]()
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 1, minor: 1)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 1, minor: 2)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 1, minor: 3)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 2, minor: 4)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 2, minor: 5)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 2, minor: 6)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 3, minor: 7)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 3, minor: 8)))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 3, minor: 9)))
        return checkpointList
    }()
    
    init(authenticationManager: AuthenticationManager){
        self.authenticationManager = authenticationManager
        self.authenticationManager.delegate = self
    }
    
    convenience init(){
        self.init(authenticationManager: AuthenticationManagerImpl())
    }
    
    private func findCheckpoint(withBeaconIdentity beaconIdentify: BeaconIdentity) -> Checkpoint?{
        if let checkpointForBeaconIdentity = checkpoints.filter({ $0.identity == beaconIdentify }).first{
            return checkpointForBeaconIdentity
        }
        return nil
    }
    
    private func requestClearingOfCheckpoint(withBeaconIdentity beaconIdentity: BeaconIdentity){
        guard let checkpoint = findCheckpoint(withBeaconIdentity: beaconIdentity) where checkpoint.cleared == false else{
            return
        }
        authenticationManager.requestUserAuthentication(forCheckpoint: checkpoint)
    }
}

extension CheckpointManagerImpl: BeaconManagerDelegate{
    func beaconManager(didCalculateNearestBeacon beacon: CLBeacon) {
        // TODO: call light service
        
        guard(authenticationManager.state == AuthenticationManagerState.Ready) else{
            return
        }
        
        switch(beacon.proximity)
        {
        case CLProximity.Immediate:
            print(String(format: "Immediate\nRSSI: %d\nAccuracy: %.4fm", beacon.rssi, beacon.accuracy))
            requestClearingOfCheckpoint(withBeaconIdentity: beacon.beaconIdentity())
        case CLProximity.Near:
            print(String(format: "Near\nRSSI: %d\nAccuracy: %.4fm", beacon.rssi, beacon.accuracy))
        case CLProximity.Far:
            print(String(format: "Far\nRSSI: %d\nAccuracy: %.4fm", beacon.rssi, beacon.accuracy))
        default:
            print("Unknown " + String(beacon.rssi))
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

extension CheckpointManagerImpl: AuthenticationManagerDelegate{
    func authenticationManager(authenticationEndedWithError errorMessage: String) {
        print(errorMessage)
    }
    
    func authenticationWasSuccessful(forCheckpoint checkpoint: Checkpoint) {
        checkpoint.cleared = true
        delegate?.checkpointManager(didClearCheckpoint: checkpoint)
    }
}