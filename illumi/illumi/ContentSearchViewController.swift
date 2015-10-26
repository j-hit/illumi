//
//  ContentSearchViewController.swift
//  illumi
//
//  Created by James Bampoe on 24/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import UIKit

class ContentSearchViewController: UIViewController {

    let resourceManager = ResourceManager.sharedInstance // TODO: use lazy
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if resourceManager.resourcesAreRequiredByUserAction(){
            performSegueWithIdentifier("showRequiredSettings", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
