//
//  FirstViewController.swift
//  illumi
//
//  Created by James Bampoe on 02/10/15.
//  Copyright © 2015 James Bampoe. All rights reserved.
//

import UIKit
import CoreLocation

class CheckpointsViewController: UITableViewController {
    lazy var checkpointManager: CheckpointManagerImpl = CheckpointManagerImpl() // TODO: only use protocol
    
    var beaconManager: BeaconManager?{
        didSet{
            beaconManager?.delegate = checkpointManager
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkpointManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        print("Segment changed: \(sender.selectedSegmentIndex)")
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkpointManager.checkpoints.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CheckpointTableViewCell.identifier, forIndexPath: indexPath) as! CheckpointTableViewCell
        
        let checkpoint = checkpointManager.checkpoints[indexPath.row]
        cell.descriptionLabel.text = checkpoint.asString()
        
        if(checkpoint.cleared){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        return cell
    }
}

extension CheckpointsViewController: CheckpointManagerDelegate{
    func checkpointManager(didClearCheckpoint checkpoint: Checkpoint) {
        // TODO: find out what to do
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func checkpointManager(didUpdateOrderOfCheckpoints checkpoints: [Checkpoint]) {
        
    }
}
