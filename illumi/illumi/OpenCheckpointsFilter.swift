//
//  OpenCheckpointsFilter.swift
//  illumi
//
//  Created by James Bampoe on 11/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

class OpenCheckpointsFilter: CheckpointsFilter{
    private let originalCheckpointArray: [Checkpoint]
    private var filteredCheckpointArray = [Checkpoint]()
    
    required init(checkpoints: [Checkpoint]) {
        originalCheckpointArray = checkpoints
        filter()
    }
    
    func filteredCheckpoints() -> [Checkpoint] {
        return filteredCheckpointArray
    }
    
    func filter(){
        filteredCheckpointArray = originalCheckpointArray.filter{ $0.cleared == false }
    }
}