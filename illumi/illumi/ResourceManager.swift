//
//  ResourceManager.swift
//  illumi
//
//  Created by James Bampoe on 24/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth
import UIKit

protocol ResourceManagerDelegate{
    func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings)
}

final class ResourceManager{
    static let sharedInstance = ResourceManager()
    
    lazy var bluetoothPeripheralManager: CBPeripheralManager = {
        return CBPeripheralManager()
    }()

    lazy var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()
    
    var delegate: ResourceManagerDelegate?
    
    private init(){
    }
    
    func resourcesAreRequiredByUserAction() -> Bool{
        checkBluetoothConnection()
        
        return locationAuthorizationIsRequired()
    }
    
    private func checkBluetoothConnection(){
        print("Bluetooth Peripherial Manager" + " \(bluetoothPeripheralManager.state.rawValue)")
    }
    
    // MARK: Access to location
    
    func locationAuthorizationIsRequired()->Bool{
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            return false
        }
        return true
    }
    
    func requestLocationAuthorization(){
        locationManager.requestAlwaysAuthorization()
    }
    
    func setLocationManagerDelegate(locationManagerdelegate: CLLocationManagerDelegate?){
        locationManager.delegate = locationManagerdelegate
    }
    
    func locationAuthorizationStatus()->CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    
    // MARK: Notifications
    
    func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings){
        delegate?.didRegisterUserNotificationSettings(notificationSettings)
    }
}