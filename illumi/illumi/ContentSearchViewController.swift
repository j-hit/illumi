//
//  ContentSearchViewController.swift
//  illumi
//
//  Created by James Bampoe on 24/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import UIKit
import CoreLocation

class ContentSearchViewController: UIViewController {
    
    let resourceManager = ResourceManager.sharedInstance
    let beaconManager: BeaconManager = BeaconManagerImpl.sharedInstance
    
    static let segueIdentifierToShowRequiredSettings = "showRequiredSettings"
    static let segueIdentifierToShowMainContent = "showMainContent"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if resourceManager.resourcesAreRequiredByUserAction(){
            performSegueWithIdentifier(ContentSearchViewController.segueIdentifierToShowRequiredSettings, sender: self) // TODO: remove hard coded string
        }else{
            beaconManager.delegate = self
            beaconManager.startRanging()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

extension ContentSearchViewController: BeaconManagerDelegate{
    func beaconManager(didCalculateNearestBeacon beacon: CLBeacon) {
        print(beacon.asString())
    }
    
    func beaconManager(didRangeBeacons beacons: [CLBeacon]) {
        beaconManager.delegate = nil // resign as delegate
        performSegueWithIdentifier(ContentSearchViewController.segueIdentifierToShowMainContent, sender: self)
    }
}
