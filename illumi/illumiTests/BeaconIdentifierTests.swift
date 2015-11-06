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

class BeaconIdentifierTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
