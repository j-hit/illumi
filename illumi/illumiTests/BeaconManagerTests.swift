//
//  BeaconManagerTests.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import XCTest
import CoreLocation
@testable import illumi

class BeaconManagerTests: XCTestCase {
    
    class BeaconManagerDelegateMock: BeaconManagerDelegate{
        var nearestBeacon: CLBeacon?
        var rangedBeacons: [CLBeacon]?
        func beaconManager(didCalculateNearestBeacon beacon: CLBeacon) {
            nearestBeacon = beacon
        }
        func beaconManager(didRangeBeacons beacons: [CLBeacon]) {
            rangedBeacons = beacons
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBeaconManagerDelegateShouldNotBeNil() {
        let beaconManager = BeaconManagerImpl()
        beaconManager.delegate = BeaconManagerDelegateMock()
        XCTAssertNotNil(beaconManager.delegate)
    }
    
    func testBeaconManagerDelegateShouldReceiveRangedBeacons(){
        let beaconManager = BeaconManagerImpl()
        let beaconManagerDelegate = BeaconManagerDelegateMock()
        beaconManager.delegate = beaconManagerDelegate
        let rangedBeacons = [CLBeaconMock(major: 1, minor: 2), CLBeaconMock(major: 2, minor: 3)]
            
        beaconManager.beaconsLastFound = rangedBeacons
        XCTAssertEqual(rangedBeacons, beaconManagerDelegate.rangedBeacons!)
    }
    
    func testBeaconManagerDelegateShouldReceiveNearestBeacon(){
        let beaconManager = BeaconManagerImpl()
        let beaconManagerDelegate = BeaconManagerDelegateMock()
        beaconManager.delegate = beaconManagerDelegate
        let nearestBeacon = CLBeaconMock(major: 4, minor: 5)
        
        beaconManager.nearestBeacon = nearestBeacon
        XCTAssertEqual(beaconManager.nearestBeacon, beaconManagerDelegate.nearestBeacon)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
