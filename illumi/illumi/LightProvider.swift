//
//  LightProvider.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

protocol LightProvider{
    func turnOnLights(withIdentifiers identifiers: Set<Int32>)
    func turnOffLights(withIdentifiers identifiers: Set<Int32>)
}