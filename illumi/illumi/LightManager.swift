//
//  LightManager.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

protocol LightManager{
    func haveLightsOnInRangeOfLight(withBeaconIdentity identity: BeaconIdentity)
}