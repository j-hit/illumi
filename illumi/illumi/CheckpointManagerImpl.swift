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
    var lightManager: LightManager
    
    lazy var checkpoints: [Checkpoint] = {
        var checkpointList = [Checkpoint]()
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 1, minor: 1), description: "Zaehlerweg 3 - 102"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 1, minor: 2), description: "Zaehlerweg 3 - 213"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 1, minor: 3), description: "Zaehlerweg 3 - 384"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 2, minor: 4), description: "Zaehlerweg 3 - 452"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 2, minor: 5), description: "Zaehlerweg 5 - 550"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 2, minor: 6), description: "Zaehlerweg 5 - 673"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 3, minor: 7), description: "Zaehlerweg 7 - 781"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 3, minor: 8), description: "Zaehlerweg 7 - 833"))
        checkpointList.append(Checkpoint(identity: BeaconIdentity(major: 3, minor: 9), description: "Zaehlerweg 9 - 962"))
        return checkpointList
    }()
    
    init(authenticationManager: AuthenticationManager, lightManager: LightManager){
        self.lightManager = lightManager
        self.authenticationManager = authenticationManager
        self.authenticationManager.delegate = self
    }
    
    convenience init(){
        self.init(authenticationManager: AuthenticationManagerImpl(), lightManager: LightManagerImpl())
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
        lightManager.haveLightsOnInRangeOfLight(withBeaconIdentity: beacon.beaconIdentity())
        
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
        
    }
    
    func beaconManager(didRangeNearestBeacons beacons: [CLBeacon]) {
        var checkpointsAssignedToRangedBeacons = [Checkpoint]()
        for beacon in beacons{
            if let checkpoint = findCheckpoint(withBeaconIdentity: beacon.beaconIdentity()){
                checkpointsAssignedToRangedBeacons.append(checkpoint)
            }
        }
        delegate?.checkpointManager(didUpdateNearestCheckpoints: checkpointsAssignedToRangedBeacons)
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