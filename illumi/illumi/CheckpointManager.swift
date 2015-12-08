//
//  CheckpointManager.swift
//  illumi
//
//  Created by James Bampoe on 06/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

protocol CheckpointManagerDelegate{
    func checkpointManager(didClearCheckpoint checkpoint: Checkpoint)
    func checkpointManager(didUpdateNearestCheckpoints checkpoints: [Checkpoint])
}

protocol CheckpointManager: BeaconManagerDelegate{
    var delegate: CheckpointManagerDelegate? { get set }
    var checkpoints: [Checkpoint] { get }
    func resetRelatedInformation()
}