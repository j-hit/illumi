//
//  AuthenticationManagerImpl.swift
//  illumi
//
//  Created by James Bampoe on 07/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import LocalAuthentication


final class AuthenticationManagerImpl: AuthenticationManager{
    var delegate: AuthenticationManagerDelegate?
    
    private (set) var state: AuthenticationManagerState = AuthenticationManagerState.Ready
    
    func requestUserAuthentication(forCheckpoint checkpoint: Checkpoint){
        let context = LAContext()
        var touchIDAvailablitityError: NSError?
        let reasonString = NSLocalizedString("TouchIDReasonString", comment: "Info message: Touch ID requested")
        
        if touchIDIsAvailable(touchIDAvailablitityError){
            state = AuthenticationManagerState.RequestingAuthentication
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evaluatePolicyError: NSError?) -> Void in
                if success{
                    self.delegate?.authenticationWasSuccessful(forCheckpoint: checkpoint)
                }
                else{
                    print(evaluatePolicyError?.localizedDescription)
                    if let authenticationError = evaluatePolicyError{
                        let resultDescription = self.errorMessage(forLocalAuthenticationError: authenticationError)
                        self.delegate?.authenticationManager(authenticationEndedWithError: resultDescription)
                    }
                }
                self.state = AuthenticationManagerState.Ready
            })
        }else{
            if let authenticationError = touchIDAvailablitityError{
                let resultDescription = self.errorMessage(forLocalAuthenticationError: authenticationError)
                delegate?.authenticationManager(authenticationEndedWithError: resultDescription)
            }
        }
    }
    
    private func errorMessage(forLocalAuthenticationError locationAuthenticationError: NSError) -> String{
        let errorMessage: String
        
        switch(locationAuthenticationError.code){
        case LAError.SystemCancel.rawValue:
            errorMessage = NSLocalizedString("LocalAuthenticationSystemCancel", comment: "Info message: Local authentication cancelled by system")
        case LAError.UserCancel.rawValue:
            errorMessage = NSLocalizedString("LocalAuthenticationUserCancel", comment: "Info message: Local authentication cancelled by user")
        case LAError.UserFallback.rawValue:
            errorMessage = NSLocalizedString("LocalAuthenticationUserFallback", comment: "Info message: User chose to enter custom password")
        case LAError.TouchIDNotEnrolled.rawValue:
            errorMessage = NSLocalizedString("LocalAuthenticationTouchIDNotEnrolled", comment: "Info message: TouchID is not enrolled")
        case LAError.PasscodeNotSet.rawValue:
            errorMessage = NSLocalizedString("LocalAuthenticationPasscodeNotSet", comment: "Info message: Local authentication cancelled by system")
        default:
            errorMessage = NSLocalizedString("LocalAuthenticationGenericError", comment: "Info message: Error occurred while using local authentication")
        }
        
        return errorMessage
    }
    
    private func touchIDIsAvailable(var error: NSError?) -> Bool{
        return LAContext().canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}