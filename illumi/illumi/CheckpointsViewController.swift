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
    let barTintColor = UIColor.grayColor()
    
    lazy var checkpointManager: CheckpointManagerImpl = CheckpointManagerImpl() // TODO: only use protocol
    
    var beaconManager: BeaconManager?{
        didSet{
            beaconManager?.delegate = checkpointManager
        }
    }
    
    var checkpointsFilter: CheckpointsFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkpointsFilter = AllCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        checkpointManager.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = barTintColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex){
        case 0:
            checkpointsFilter = AllCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        case 1:
            checkpointsFilter = OpenCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        case 2:
            checkpointsFilter = ClearedCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        default:
            checkpointsFilter = AllCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkpointsFilter?.filteredCheckpoints().count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CheckpointTableViewCell.identifier, forIndexPath: indexPath) as! CheckpointTableViewCell
        
        guard let checkpoint = checkpointsFilter?.filteredCheckpoints()[indexPath.row] else{
            return cell
        }
        
        cell.descriptionLabel.text = checkpoint.asString()
        
        if(checkpoint.cleared){
            cell.statusLabel.text = String(format: NSLocalizedString("CheckpointTimeClearedDescriptionFormat", comment: "Format for description of when a checkpoint was cleared"), NSLocalizedString("CheckpointClearedAt", comment: "Checkpoint info: Describing that a checkpoint was cleared at a specific time"), checkpoint.timeStampWhenCheckpointWasClearedAsString())
            cell.accessoryType = .Checkmark
        }else{
            cell.statusLabel.text = ""
            cell.accessoryType = .None
        }
        
        return cell
    }
}

extension CheckpointsViewController: CheckpointManagerDelegate{
    func checkpointManager(didClearCheckpoint checkpoint: Checkpoint) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                self.navigationController?.navigationBar.barTintColor = UIColor.greenColor()
                }, completion: { (_) -> Void in
                    self.checkpointsFilter?.filter()
                    self.tableView.reloadData()
                    self.navigationController?.navigationBar.barTintColor = self.barTintColor
            })
        }
    }
    
    func checkpointManager(didUpdateOrderOfCheckpoints checkpoints: [Checkpoint]) {
        
    }
}
