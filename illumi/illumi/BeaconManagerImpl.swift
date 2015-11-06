//
//  BeaconManagerImpl.swift
//  illumi
//
//  Created by James Bampoe on 31/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

final class BeaconManagerImpl: NSObject{
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
    
    override init(){
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
        locationManager.startRangingBeaconsInRegion(CLBeaconRegion(proximityUUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, identifier: BeaconIdentityProvider.illumiBeaconsIdentifier))
    }
    
    func startMonitoring(){
        startMonitoringForIllumis()
        startMonitoringForEntrance()
        startMonitoringForExit()
    }
    
    private func startMonitoringForIllumis(){
        locationManager.startMonitoringForRegion(CLBeaconRegion(proximityUUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, identifier: BeaconIdentityProvider.illumiBeaconsIdentifier))
    }
    
    private func startMonitoringForEntrance(){
        let entranceBeaconIdentity = BeaconIdentityProvider.entrance()
        let entranceRegion = CLBeaconRegion(
            proximityUUID: entranceBeaconIdentity.UUID,
            major: CLBeaconMajorValue(entranceBeaconIdentity.major) ?? 0, minor: CLBeaconMinorValue(entranceBeaconIdentity.minor) ?? 0, identifier: BeaconIdentityProvider.entranceIdentifier)
        entranceRegion.notifyOnExit = false
        locationManager.startMonitoringForRegion(entranceRegion)
    }
    
    private func startMonitoringForExit(){
        let exitBeaconIdentifier = BeaconIdentityProvider.exit()
        let exitRegion = CLBeaconRegion(
            proximityUUID: exitBeaconIdentifier.UUID,
            major: CLBeaconMajorValue(exitBeaconIdentifier.major) ?? 0, minor: CLBeaconMinorValue(exitBeaconIdentifier.minor) ?? 0, identifier: BeaconIdentityProvider.exitIdentifier)
        exitRegion.notifyOnEntry = false
        locationManager.startMonitoringForRegion(exitRegion)
    }
}

extension BeaconManagerImpl: CLLocationManagerDelegate{
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == BeaconIdentityProvider.entranceIdentifier {
            let notification = UILocalNotification()
            notification.alertBody = NSLocalizedString("EntranceEnteredNotification", comment: "Notification: entrance region entered")
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            print("didEnterRegion")
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == BeaconIdentityProvider.exitIdentifier {
            let notification = UILocalNotification()
            notification.alertBody = NSLocalizedString("ExitLeftNotification", comment: "Notification: exit region left")
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            print("didEnterRegion")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
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