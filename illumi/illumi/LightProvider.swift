//
//  LightProvider.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

protocol LightProviderDelegate{
    func didTurnOnLight(withIdentifier identifier: Int32)
    func didTurnOffLight(withIdentifier identifier: Int32)
}

protocol LightProvider{
    var delegate: LightProviderDelegate? { get set }
    func turnOnLights(withIdentifiers identifiers: Set<Int32>)
    func turnOffLights(withIdentifiers identifiers: Set<Int32>)
    func identifiersOfAllLights() -> Set<Int32>
}