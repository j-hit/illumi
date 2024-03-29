//
//  BeaconManager.swift
//  illumi
//
//  Created by James Bampoe on 31/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconManagerDelegate{
    func beaconManager(didRangeBeacons beacons: [CLBeacon])
    func beaconManager(didCalculateNearestBeacon beacon: CLBeacon)
    func beaconManager(didRangeNearestBeacons beacons: [CLBeacon])
}

protocol BeaconManager: class{
    var delegate: BeaconManagerDelegate? { get set }
    func sortBeaconsAccordingToProximityAndAccuracy(beacons: [CLBeacon]) -> [CLBeacon]?
    func startRanging()
    func startMonitoring()
}