//
//  SettingsViewController.swift
//  illumi
//
//  Created by James Bampoe on 02/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        if let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

