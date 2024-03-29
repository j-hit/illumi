//
//  DesigoCCLightProvider.swift
//  illumi
//
//  Created by James Bampoe on 13/11/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import Alamofire

final class DesigoCCLightProvider{
    var delegate: LightProviderDelegate?
    
    private var iPAddress: String{
        if let userDefinedIPAddress = NSUserDefaults.standardUserDefaults().stringForKey("webServiceIPAddress") where
            !userDefinedIPAddress.isEmpty{
                return userDefinedIPAddress
        }else{
            return "172.20.10.9"
        }
    }
    
    private var baseURL: String{
        return "http://\(iPAddress)/wsi/api"
    }
    private var accessToken: String?
    
    private enum LightState: Int{
        case Off = 0
        case On = 1
    }
    
    private let WebServiceLightIdentifiers: [Int32 : String] = [
        1 : "16777217",
        2 : "16777218",
        3 : "16777219",
        4 : "16777220",
        5 : "16777221",
        6 : "16777222",
        7 : "16777223",
        8 : "16777224"
    ]
    
    init(){
        requestAccessToken()
    }
    
    private func requestAccessToken(){
        Alamofire.request(.POST, baseURL + "/token", headers: headerForAccessToken(), parameters: parametersForAccessToken())
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
    
    private func headerForAccessToken() -> [String : String]{
        return [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
    
    private func parametersForAccessToken() -> [String : AnyObject]{
        return [
            "grant_type": "password",
            "username": "DefaultAdmin",
            "password": "Test1234"
        ]
    }
    
    private func requestLight(withIdentifier identifier: Int32, toBeSwitchedToState state: LightState){
        guard let url = URLForChangingPresentValueOfLight(withIdentifier: identifier),
            urlRequest = URLRequestForChangingPresentValue(withURLString: url, toValue: state.rawValue) else{
                return
        }
        
        Alamofire.request(urlRequest)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success:
                    if(state == .On){
                        self.delegate?.didTurnOnLight(withIdentifier: identifier)
                        NSLog(String(format: "Successfully turned light with identifier %d to on", identifier))
                    } else{
                        self.delegate?.didTurnOffLight(withIdentifier: identifier)
                        NSLog(String(format: "Successfully turned light with identifier %d to off", identifier))
                    }
                case .Failure(let error):
                    print(error)
                    if response.response?.statusCode == 401{
                        NSLog("\nFailure due to an Unauthorized error")
                        self.requestAccessToken()
                    }
                }
        }
    }
    
    private func bodyForChangingPresentValue(toValue value: Int) -> [NSDictionary]{
        return [
            ["Name": "Value", "Value": value, "DataType": "ExtendedEnum"]
        ]
    }
    
    private func URLForChangingPresentValueOfLight(withIdentifier identifier: Int32) -> String?{
        guard let webServiceLightIdentifier = WebServiceLightIdentifiers[identifier] else{
            return nil
        }
        
        return baseURL + "/commands/GmsDevice_1_3457_\(webServiceLightIdentifier).Present_Value/Write"
    }
    
    private func URLRequestForChangingPresentValue(withURLString url: String, toValue value: Int) -> NSURLRequest?{
        guard let accessToken = accessToken else{
            return nil
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyForChangingPresentValue(toValue: value), options: [])
        return request
    }
}

extension DesigoCCLightProvider: LightProvider{
    func turnOffLights(withIdentifiers identifiers: Set<Int32>) {
        for identifier in identifiers{
            requestLight(withIdentifier: identifier, toBeSwitchedToState: .Off)
        }
    }
    
    func turnOnLights(withIdentifiers identifiers: Set<Int32>) {
        for identifier in identifiers{
            requestLight(withIdentifier: identifier, toBeSwitchedToState: .On)
        }
    }
    
    func identifiersOfAllLights() -> Set<Int32> {
        return Set<Int32>(WebServiceLightIdentifiers.keys)
    }
}