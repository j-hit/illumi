//
//  LightManagerImpl.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

final class LightManagerImpl: LightManager{
    private var lightsTurnedOn = Set<Int32>()
    private var lightProvider: LightProvider
    
    init(lightProvider: LightProvider){
        self.lightProvider = lightProvider
    }
    
    convenience init(){
        self.init(lightProvider: DesigoCCLightProvider())
    }
    
    func haveLightsOnInRangeOfLight(withBeaconIdentity identity: BeaconIdentity){
        guard(identity.minor != 0) else{
            return
        }
        
        let lightsToBeOn: Set<Int32> = calculateLightsToBeOn(accordingToIdentifier: identity.minor)
        
        let lightsToBeTurnedOn = calculateLightsToBeTurnedOn(lightsToBeOn)
        lightProvider.turnOnLights(withIdentifiers: lightsToBeTurnedOn)
        
        let lightsToBeTurnedOff = calculateLightsToBeTurnedOff(lightsToBeOn)
        lightProvider.turnOffLights(withIdentifiers: lightsToBeTurnedOff)
        
        lightsTurnedOn = lightsToBeOn
    }
    
    private func calculateLightsToBeOn(accordingToIdentifier identifier: Int32) -> Set<Int32>{
        var lightsToBeOn: Set<Int32>
        switch(identifier){
        case 1:
            lightsToBeOn = [1, 2, 3]
        default:
            lightsToBeOn = [identifier-1, identifier, identifier+1, identifier+2]
        }
        return lightsToBeOn
    }
    
    private func calculateLightsToBeTurnedOn(lightsToBeOn: Set<Int32>) -> Set<Int32>{
        return lightsToBeOn.subtract(lightsTurnedOn)
    }
    
    private func calculateLightsToBeTurnedOff(lightsToBeOn: Set<Int32>) -> Set<Int32>{
        return lightsTurnedOn.subtract(lightsToBeOn)
    }
}