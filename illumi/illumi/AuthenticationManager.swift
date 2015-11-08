//
//  AuthenticationManager.swift
//  illumi
//
//  Created by James Bampoe on 07/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation

protocol AuthenticationManagerDelegate{
    func authenticationWasSuccessful(forCheckpoint checkpoint: Checkpoint)
    func authenticationManager(authenticationEndedWithError errorMessage: String)
}

enum AuthenticationManagerState{
    case Ready
    case RequestingAuthentication
}

protocol AuthenticationManager{
    var delegate: AuthenticationManagerDelegate? { get set }
    var state: AuthenticationManagerState { get }
    func requestUserAuthentication(forCheckpoint checkpoint: Checkpoint)
}