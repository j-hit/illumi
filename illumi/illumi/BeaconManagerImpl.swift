//
//  BeaconManagerImpl.swift
//  illumi
//
//  Created by James Bampoe on 31/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManagerImpl: NSObject{
    static let sharedInstance = BeaconManagerImpl()
    
    var delegate: BeaconManagerDelegate?
    
    let locationManager: CLLocationManager
    
    var beaconsLastFound: [CLBeacon]?{
        didSet{
            if let beacons = beaconsLastFound{
                delegate?.beaconManager(didRangeBeacons: beacons)
            }
        }
    }
    
    var nearestBeacon: CLBeacon?{
        didSet{
            if let beacon = nearestBeacon{
                delegate?.beaconManager(didCalculateNearestBeacon: beacon)
            }
        }
    }
    
    private override init(){
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    
}

extension BeaconManagerImpl: BeaconManager{
    // MARK: BeaconManager
    
    func findNearestBeacon(beacons: [CLBeacon]) -> CLBeacon?{
        guard beacons.count > 0 else{
            return nil
        }
        var nearestBeacon = beacons.first!
        
        // Remove unknown beacons
        var beaconsInRange = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if beaconsInRange.count > 0{
            beaconsInRange.sortInPlace({ $0.proximity.rawValue < $1.proximity.rawValue })
            nearestBeacon = beaconsInRange.first!
            
            // Only deal with beacons of the nearest proximity
            var beaconsWithNearestProximity = beaconsInRange.filter{ $0.proximity == nearestBeacon.proximity }
            beaconsWithNearestProximity.sortInPlace({ $0.accuracy < $1.accuracy })
            nearestBeacon = beaconsWithNearestProximity.first!
        }
        
        return nearestBeacon
    }
    
    func startRanging(){
        locationManager.startRangingBeaconsInRegion(CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "6440D3EA-2361-4DB9-BDC3-2388C795FB4C")!, identifier: "illumiBeacons"))
    }
}

extension BeaconManagerImpl: CLLocationManagerDelegate{
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // TODO: handle failure
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if let nearestBeaconFound = findNearestBeacon(beacons){
            nearestBeacon = nearestBeaconFound
        }
        beaconsLastFound = beacons
    }
}

extension CLBeacon{
    func asString() -> String{
        return "Major: \(major) Minor: \(minor)\nProximity: \(proximity.rawValue)\nRSSI: \(rssi)\nAccuracy: \(accuracy)"
    }
}