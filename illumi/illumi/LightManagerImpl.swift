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
        self.lightProvider.delegate = self
    }
    
    func haveLightsOnInRangeOfLight(withBeaconIdentity identity: BeaconIdentity){
        guard(identity.minor != 0) else{
            return
        }
        
        let lightsToBeOn: Set<Int32> = calculateLightsToBeOn(accordingToIdentifier: identity.minor)
        
        lightProvider.turnOnLights(withIdentifiers: calculateLightsToBeTurnedOn(lightsToBeOn))
        lightProvider.turnOffLights(withIdentifiers: calculateLightsToBeTurnedOff(lightsToBeOn))
    }
    
    private func calculateLightsToBeOn(accordingToIdentifier identifier: Int32) -> Set<Int32>{
        var lightsToBeOn: Set<Int32>
        switch(identifier){
        case 1:
            lightsToBeOn = [1, 2, 3]
        case 9:
            lightsToBeOn = []
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

extension LightManagerImpl: LightProviderDelegate{
    func didTurnOffLight(withIdentifier identifier: Int32) {
        lightsTurnedOn.remove(identifier)
    }
    
    func didTurnOnLight(withIdentifier identifier: Int32) {
        lightsTurnedOn.insert(identifier)
    }
}