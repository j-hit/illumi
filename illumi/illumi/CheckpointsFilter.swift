//
//  CheckpointsFilter.swift
//  illumi
//
//  Created by James Bampoe on 11/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

protocol CheckpointsFilter{
    init(checkpoints: [Checkpoint])
    
    func filteredCheckpoints() -> [Checkpoint]
    func filter()
}