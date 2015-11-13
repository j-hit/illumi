//
//  DesigoCCLightProvider.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

class DesigoCCLightProvider: LightProvider{
    func turnOffLights(withIdentifiers identifiers: Set<Int32>) {
        
    }
    
    func turnOnLights(withIdentifiers identifiers: Set<Int32>) {
        if(identifiers.contains(1)){
            print("test for turning on the lights")
        }
    }
}