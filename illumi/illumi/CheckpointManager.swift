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
    func checkpointManager(didUpdateOrderOfCheckpoints checkpoints: [Checkpoint])
}

protocol CheckpointManager: class{
    
}