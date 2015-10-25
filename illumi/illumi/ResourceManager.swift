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

class ResourceManager{
    static let sharedInstance = ResourceManager()
    
    lazy var bluetoothPeripheralManager: CBPeripheralManager = {
        return CBPeripheralManager()
    }()

    let locationManager: CLLocationManager
    
    var delegate: ResourceManagerDelegate?
    
    private init(){
        locationManager = CLLocationManager()
    }
    
    func resourcesRequiredByUserAction() -> Bool{
        checkBluetoothConnection()
        if(locationAuthorizationIsRequired()){
            return true
        }
        return false
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
    
    func locationAuthorizationStatus()->CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    func requestLocationAuthorization(){
        locationManager.requestAlwaysAuthorization()
    }
    
    func setLocationManagerDelegate(locationManagerdelegate: CLLocationManagerDelegate){
        locationManager.delegate = locationManagerdelegate
    }
    
    // MARK: Notifications
    func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings){
        delegate?.didRegisterUserNotificationSettings(notificationSettings)
    }
}