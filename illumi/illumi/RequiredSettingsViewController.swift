//
//  RequiredSettingsViewController.swift
//  illumi
//
//  Created by James Bampoe on 24/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class RequiredSettingsViewController: UIViewController {
    
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    let resourceManager = ResourceManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resourceManager.delegate = self
        resourceManager.setLocationManagerDelegate(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView(){
        setLocationInfoAccordingToAuthorizationStatus(resourceManager.locationAuthorizationStatus())
        setNotificationInfoAccordingToUserNotificationSettings(UIApplication.sharedApplication().currentUserNotificationSettings())
    }
    
    // MARK: Access to location
    
    private func setLocationInfoAccordingToAuthorizationStatus(status: CLAuthorizationStatus){
        switch(status){
        case .AuthorizedAlways:
            locationSwitch.on = true
            locationSwitch.enabled = false
            setLocationInfoLabel("")
        case .Denied:
            locationSwitch.on = false
            locationSwitch.enabled = false
            setLocationInfoLabel(NSLocalizedString("LocationDenied", comment: "Info message: Location denied"))
        case .NotDetermined:
            locationSwitch.on = false
            locationSwitch.enabled = true
        case .Restricted:
            locationSwitch.on = false
            locationSwitch.enabled = false
            setLocationInfoLabel(NSLocalizedString("LocationRestricted", comment: "Info message: Location restricted"))
        default:
            locationSwitch.on = false
        }
    }
    
    private func setLocationInfoLabel(infoLabelText: String){
        locationInfoLabel.text = infoLabelText
    }
    
    @IBAction func askForAccessToLocation(sender: UISwitch) {
        resourceManager.requestLocationAuthorization()
    }
    
    // MARK: Notification settings
    
    @IBAction func requestLocalNotifications(sender: UISwitch) {
        notificationSwitch.enabled = false
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: .Alert, categories: nil))
    }
    
    private func setNotificationInfoAccordingToUserNotificationSettings(notificationSettings: UIUserNotificationSettings?){
        if let notificationSettings = notificationSettings{
            notificationSwitch.on = notificationSettings.types.contains(.Alert) ? true : false
        }
    }
    
    // MARK: Done button
    @IBAction func doneButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RequiredSettingsViewController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        setLocationInfoAccordingToAuthorizationStatus(status)
    }
}

extension RequiredSettingsViewController: ResourceManagerDelegate{
    func didRegisterUserNotificationSettings(notificationSettings: UIUserNotificationSettings) {
        setNotificationInfoAccordingToUserNotificationSettings(notificationSettings)
    }
}
