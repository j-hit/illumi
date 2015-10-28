//
//  illumiTests.swift
//  illumiTests
//
//  Created by James Bampoe on 02/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import XCTest
@testable import illumi

class illumiTests: XCTestCase {
    
    var resourceManager: ResourceManager?
    
    override func setUp() {
        super.setUp()
        resourceManager = ResourceManager.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBluetoothPeripheralShouldNotNil() {
        XCTAssertNotNil(resourceManager!.bluetoothPeripheralManager)
    }
    
    func testLocationManagerShouldNotNil(){
        XCTAssertNotNil(resourceManager!.locationManager)
    }
    
    func testResourceManagerDelegateShouldBeNil(){
        resourceManager!.delegate = nil
        XCTAssertNil(resourceManager!.delegate)
    }
    
    func testResourceManagerDelegateShouldNotNil(){
        let resourceManagerDelegate = RequiredSettingsViewController()
        resourceManager!.delegate = resourceManagerDelegate
        XCTAssertNotNil(resourceManager!.delegate)
    }
    
    func testResourceManagerInstancesShouldBeTheSame(){
        let secondInstanceOfResourceManager = ResourceManager.sharedInstance
        XCTAssert(resourceManager! === secondInstanceOfResourceManager)
    }
    
    func testLocationAuthorizationMandatory(){
        let locationAuthorizationIsRequired = resourceManager!.locationAuthorizationIsRequired()
        if locationAuthorizationIsRequired{
            XCTAssert(resourceManager!.resourcesAreRequiredByUserAction() == true)
        }else{
            XCTAssert(resourceManager!.resourcesAreRequiredByUserAction() == false)
        }
    }
    
    func testLocationManagerDelegateShouldBeNil(){
        resourceManager!.setLocationManagerDelegate(nil)
        XCTAssert(resourceManager!.locationManager.delegate == nil)
    }
    
    // MARK: Performace test cases
    
    func testPerformanceResourcesAreRequiredCheck() {
        self.measureBlock {
            self.resourceManager!.resourcesAreRequiredByUserAction()
        }
    }
    
}
