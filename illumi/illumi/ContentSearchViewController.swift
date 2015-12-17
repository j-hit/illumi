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
    
    @IBOutlet weak var additionalDetailsLabel: UILabel!
    
    @IBAction func viewDidGetSingleTapped(sender: UITapGestureRecognizer) {
        additionalDetailsLabel.alpha = 0
        additionalDetailsLabel.text = NSLocalizedString("LocationMaybeNotSupported", comment: "Info message: Probably not at a supported location")
        UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.additionalDetailsLabel.alpha = 1
            }) { (done) -> Void in
                self.additionalDetailsLabel.text = ""
        }
    }
    
    @IBAction func viewDidDetectLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Recognized{
            additionalDetailsLabel.text = NSLocalizedString("DemoModeStarting", comment: "Info message: Demo mode starting")
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                    self.view.alpha = 0
                }, completion: { (done) -> Void in
                    self.performSegueWithIdentifier(ContentSearchViewController.segueIdentifierToShowMainContent, sender: self)
            })
        }
    }
    
    let resourceManager = ResourceManager.sharedInstance
    var beaconManager: BeaconManager = BeaconManagerImpl()
    
    static let segueIdentifierToShowRequiredSettings = "showRequiredSettings"
    static let segueIdentifierToShowMainContent = "showMainContent"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if resourceManager.resourcesAreRequiredByUserAction(){
            performSegueWithIdentifier(ContentSearchViewController.segueIdentifierToShowRequiredSettings, sender: self)
        }else{
            beaconManager.delegate = self
            beaconManager.startRanging()
            beaconManager.startMonitoring()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ContentSearchViewController.segueIdentifierToShowMainContent{
            if let tabBarController = segue.destinationViewController as? UITabBarController,
                navigationViewController = tabBarController.viewControllers?[0] as? UINavigationController,
                checkpointsViewController = navigationViewController.topViewController as? CheckpointsViewController{
                    checkpointsViewController.beaconManager = self.beaconManager
            }
        }
    }
}

extension ContentSearchViewController: BeaconManagerDelegate{
    func beaconManager(didCalculateNearestBeacon beacon: CLBeacon) {
        // Not required
    }
    
    func beaconManager(didRangeNearestBeacons beacons: [CLBeacon]) {
        // Not required
    }
    
    func beaconManager(didRangeBeacons beacons: [CLBeacon]) {
        guard beacons.count > 0 else{
            return
        }
        performSegueWithIdentifier(ContentSearchViewController.segueIdentifierToShowMainContent, sender: self)
    }
}
