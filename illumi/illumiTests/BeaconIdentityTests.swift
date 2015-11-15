//
//  BeaconIdentifierTests.swift
//  illumi
//
//  Created by James Bampoe on 04/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import XCTest
import CoreLocation
@testable import illumi

class BeaconIdentityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBeaconIdentityExtension() {
        
        let beaconObject = CLBeaconMock()
        beaconObject.proximityUUID = NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!
        beaconObject.major = 2
        beaconObject.minor = 100
        
        let beaconIdentity = beaconObject.beaconIdentity()
        XCTAssertEqual(beaconIdentity.UUID, beaconObject.proximityUUID)
        XCTAssertEqual(NSNumber(int: beaconIdentity.major), beaconObject.major)
        XCTAssertEqual(NSNumber(int: beaconIdentity.minor), beaconObject.minor)
    }
    
    func testBeaconIdentityShouldBeEqual(){
        let beaconID1 = BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 2)
        
        let beaconID2 = BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 2)
        
        XCTAssertEqual(beaconID1, beaconID2)
    }
    
    func testBeaconIdentityShouldNotBeEqual(){
        let beaconID1 = BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 2)
        
        let beaconID2 = BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 1, minor: 3)
        
        let beaconID3 = BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 2, minor: 2)
        
        let beaconID4 = BeaconIdentity(UUID: NSUUID(UUIDString: BeaconIdentityProvider.illumiUUID)!, major: 2, minor: 3)
        
        XCTAssertNotEqual(beaconID1, beaconID2)
        XCTAssertNotEqual(beaconID1, beaconID3)
        XCTAssertNotEqual(beaconID1, beaconID4)
        XCTAssertNotEqual(beaconID2, beaconID3)
        XCTAssertNotEqual(beaconID2, beaconID4)
        XCTAssertNotEqual(beaconID3, beaconID4)
    }
}
