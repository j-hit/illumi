//
//  CheckpointTests.swift
//  illumi
//
//  Created by James Bampoe on 15/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import XCTest
@testable import illumi

class CheckpointTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCheckpointShouldNotBeClearedWhenCreated() {
        let checkpoint: Checkpoint = Checkpoint(identity: BeaconIdentity(major: 1, minor: 1))
        XCTAssertEqual(checkpoint.cleared, false)
    }
    
    func testCheckpointShouldNotHaveTimeStampIfNotCleared(){
        let checkpoint: Checkpoint = Checkpoint(cleared: false, identity: BeaconIdentity(major: 1, minor: 1))
        XCTAssertEqual(checkpoint.timeStampWhenCheckpointWasClearedAsString(), "")
    }
    
    func testCheckpointShouldBeClearedWhenCreated(){
        let checkpoint: Checkpoint = Checkpoint(cleared: true, identity: BeaconIdentity(major: 1, minor: 1))
        XCTAssertEqual(checkpoint.cleared, true)
    }
    
    func testCheckpointShouldRecordTimeStampWhenCleared(){
        let checkpoint: Checkpoint = Checkpoint(identity: BeaconIdentity(major: 1, minor: 1))
        let timeStampBeforeCleared = NSDate()
        checkpoint.cleared = true
        let timeStampAfterCleared = NSDate()
        let timeBeforeClearedComparedToTimeStampWhenCleared = timeStampBeforeCleared.compare(checkpoint.timeStampWhenCleared!)
        let timeAfterClearedComparedToTimeStampWhenCleared = timeStampAfterCleared.compare(checkpoint.timeStampWhenCleared!)

        XCTAssertTrue(timeBeforeClearedComparedToTimeStampWhenCleared == .OrderedAscending || timeBeforeClearedComparedToTimeStampWhenCleared == .OrderedSame)
        XCTAssertTrue(timeAfterClearedComparedToTimeStampWhenCleared == .OrderedDescending || timeAfterClearedComparedToTimeStampWhenCleared == .OrderedSame)
    }
}
