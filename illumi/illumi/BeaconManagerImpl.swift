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
    
    var nearestBeacons: [CLBeacon]?{
        didSet{
            if let beacons = nearestBeacons{
                delegate?.beaconManager(didRangeNearestBeacons: beacons)
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

// MARK: - BeaconManager
extension BeaconManagerImpl: BeaconManager{    
    func sortBeaconsAccordingToProximityAndAccuracy(beacons: [CLBeacon]) -> [CLBeacon]?{
        guard beacons.count > 0 else{
            return nil
        }
        
        var sortedBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        sortedBeacons.sortInPlace({ $0.proximity.rawValue == $1.proximity.rawValue ? $0.accuracy < $1.accuracy : $0.proximity.rawValue < $1.proximity.rawValue })
        
        return sortedBeacons
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

// MARK: - CLLocationManagerDelegate
extension BeaconManagerImpl: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == BeaconIdentityProvider.entranceIdentifier {
            let notification = UILocalNotification()
            notification.alertBody = NSLocalizedString("EntranceEnteredNotification", comment: "Notification: entrance region entered")
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == BeaconIdentityProvider.exitIdentifier {
            let notification = UILocalNotification()
            notification.alertBody = NSLocalizedString("ExitLeftNotification", comment: "Notification: exit region left")
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if let sortedBeacons = self.sortBeaconsAccordingToProximityAndAccuracy(beacons), nearestBeaconFound = sortedBeacons.first{
            self.nearestBeacon = nearestBeaconFound
            self.nearestBeacons = sliceOffFirstThreeBeacons(fromBeaconArray: sortedBeacons)
        }
        beaconsLastFound = beacons
    }
    
    func sliceOffFirstThreeBeacons(fromBeaconArray beacons: [CLBeacon]) -> [CLBeacon]{
        if beacons.count > 3{
            return Array(beacons[0..<3])
        }else{
            return beacons
        }
    }
}