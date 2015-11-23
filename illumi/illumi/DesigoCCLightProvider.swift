//
//  DesigoCCLightProvider.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import Alamofire

class DesigoCCLightProvider{
    let baseURL = "http://172.20.10.9/wsi/api"
    var accessToken: String?
    
    enum LightState: Int{
        case Off = 0
        case On = 1
    }
    
    init(){
        requestAccessToken()
    }
    
    func requestAccessToken(){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters = [
            "grant_type": "password",
            "username": "DefaultAdmin",
            "password": "Test1234"
        ]
        
        Alamofire.request(.POST, baseURL + "/token", headers: headers, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let JSONResponse = response.result.value,
                        token = JSONResponse["access_token"]{
                            self.accessToken = token as? String
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    func requestLightToBeSwitched(toState state: LightState){
        guard let accessToken = accessToken else{
            return
        }
        
        let valueToBeSet = state.rawValue
        let requestURL = baseURL + "/commands/GmsDevice_1_1_16777217.Present_Value/WritePrio"
        let body = [
            ["Name": "Priority", "Value": 8, "DataType": "ExtendedEnum"],
            ["Name": "Value", "Value": valueToBeSet, "DataType": "ExtendedEnum"]
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body, options: [])
        
        Alamofire.request(request)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    print("successfully changed the present value")
                case .Failure(let error):
                    print(error)
                    if response.response?.statusCode == 401{
                        print("\nUnauthorized")
                        self.requestAccessToken()
                    }
                }
        }
    }
}

extension DesigoCCLightProvider: LightProvider{
    func turnOffLights(withIdentifiers identifiers: Set<Int32>) {
        
    }
    
    func turnOnLights(withIdentifiers identifiers: Set<Int32>) {
        
    }
}