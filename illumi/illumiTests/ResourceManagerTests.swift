//
//  illumiTests.swift
//  illumiTests
//
//  Created by James Bampoe on 02/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import XCTest
import CoreLocation
@testable import illumi

class ResourceManagerTests: XCTestCase {
    
    var resourceManager: ResourceManager?
    
    override func setUp() {
        super.setUp()
        resourceManager = ResourceManager.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBluetoothPeripheralShouldExist() {
        XCTAssertNotNil(resourceManager!.bluetoothPeripheralManager, "bluetooth peripheral manager should exist")
    }
    
    func testLocationManagerShouldExist(){
        XCTAssertNotNil(resourceManager!.locationManager, "location manager should exist")
    }
    
    func testResourceManagerDelegateShouldBeNil(){
        resourceManager!.delegate = nil
        XCTAssertNil(resourceManager!.delegate, "Resource manager delegate should be nil")
    }
    
    func testResourceManagerDelegateShouldNotNil(){
        class ResourceManagerDelegateMock: ResourceManagerDelegate{
            private func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings) {
            }
        }
        let resourceManagerDelegate = ResourceManagerDelegateMock()
        resourceManager!.delegate = resourceManagerDelegate
        XCTAssertNotNil(resourceManager!.delegate, "Resource manager delegate should not be nil")
    }
    
    func testResourceManagerInstancesShouldBeTheSame(){
        let secondInstanceOfResourceManager = ResourceManager.sharedInstance
        XCTAssert(resourceManager! === secondInstanceOfResourceManager, "There should only be one instance of the resource manager")
    }
    
    func testLocationAuthorizationMandatory(){
        let locationAuthorizationIsRequired = resourceManager!.locationAuthorizationIsRequired()
        if locationAuthorizationIsRequired{
            XCTAssert(resourceManager!.resourcesAreRequiredByUserAction() == true, "location authorization should require user action")
        }else{
            XCTAssert(resourceManager!.resourcesAreRequiredByUserAction() == false, "location authorization done, user action should not be required")
        }
    }
    
    func testLocationManagerDelegateShouldBeNil(){
        resourceManager!.setLocationManagerDelegate(nil)
        XCTAssert(resourceManager!.locationManager.delegate == nil, "location manager delegate should be nil")
    }
    
    func testRequestLocationAuthorization(){
        resourceManager!.requestLocationAuthorization()
    }
    
    // MARK: Performace test cases
    
    func testPerformanceResourcesAreRequiredCheck() {
        self.measureBlock {
            self.resourceManager!.resourcesAreRequiredByUserAction()
        }
    }
    
}
