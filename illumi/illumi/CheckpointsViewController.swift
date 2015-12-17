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
    @IBOutlet weak var checkpointFilterSegmentedControl: UISegmentedControl!
    
    enum CheckpointFilterSegments: Int{
        case AllCheckpoints
        case OpenCheckpoints
        case ClearedCheckpoints
    }
    
    enum CheckpointTableViewSections: Int{
        case NearestCheckpointsSection
        case AlphabeticallySortedCheckpointsSection
    }
    
    let barTintColor = UIColor.grayColor()
    
    var checkpointManager: CheckpointManager = CheckpointManagerImpl()
    
    var beaconManager: BeaconManager?{
        didSet{
            beaconManager?.delegate = checkpointManager
        }
    }
    
    var checkpointsFilter: CheckpointsFilter?
    var nearestCheckpoints: [Checkpoint]?{
        didSet{
            tableView.reloadData()
        }
    }
    
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
        case CheckpointFilterSegments.AllCheckpoints.rawValue:
            checkpointsFilter = AllCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        case CheckpointFilterSegments.OpenCheckpoints.rawValue:
            checkpointsFilter = OpenCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        case CheckpointFilterSegments.ClearedCheckpoints.rawValue:
            checkpointsFilter = ClearedCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        default:
            checkpointsFilter = AllCheckpointsFilter(checkpoints: checkpointManager.checkpoints)
        }
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(checkpointFilterSegmentedControl.selectedSegmentIndex == CheckpointFilterSegments.AllCheckpoints.rawValue){
            return 2
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == CheckpointTableViewSections.NearestCheckpointsSection.rawValue && tableView.numberOfSections > 1){
            return NSLocalizedString("NearestCheckpointsSection", comment: "Section info: Nearest checkpoints")
        }else if checkpointFilterSegmentedControl.selectedSegmentIndex == CheckpointFilterSegments.AllCheckpoints.rawValue{
            return NSLocalizedString("AllCheckpointsSection", comment: "Section info: All checkpoints")
        }else{
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == CheckpointTableViewSections.NearestCheckpointsSection.rawValue && tableView.numberOfSections > 1){
            return nearestCheckpoints?.count ?? 0
        }else{
            return checkpointsFilter?.filteredCheckpoints().count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CheckpointTableViewCell.identifier, forIndexPath: indexPath) as! CheckpointTableViewCell
        
        let checkpoint: Checkpoint?
        if(indexPath.section == CheckpointTableViewSections.NearestCheckpointsSection.rawValue && tableView.numberOfSections > 1){
            checkpoint = nearestCheckpoints?[indexPath.row]
        }else{
            checkpoint = checkpointsFilter?.filteredCheckpoints()[indexPath.row]
        }
        
        guard checkpoint != nil else{
            return cell
        }
        
        cell.descriptionLabel.text = checkpoint!.description
        
        if(checkpoint!.cleared){
            cell.statusLabel.text = String(format: NSLocalizedString("CheckpointTimeClearedDescriptionFormat", comment: "Format for description of when a checkpoint was cleared"), NSLocalizedString("CheckpointClearedAt", comment: "Checkpoint info: Describing that a checkpoint was cleared at a specific time"), checkpoint!.timeStampWhenCheckpointWasClearedAsString())
            cell.accessoryType = .Checkmark
        }else{
            cell.statusLabel.text = ""
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func viewDidDetectRotationGesture(sender: UIRotationGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended{
            checkpointManager.resetRelatedInformation()
        }
    }
}

// MARK: - CheckpointManagerDelegate
extension CheckpointsViewController: CheckpointManagerDelegate{
    func checkpointManager(didClearCheckpoint checkpoint: Checkpoint) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 110/255, green: 193/255, blue: 54/255, alpha: 1.0)
                }, completion: { (_) -> Void in
                    self.checkpointsFilter?.filter()
                    self.tableView.reloadData()
                    self.navigationController?.navigationBar.barTintColor = self.barTintColor
            })
        }
    }
    
    func checkpointManager(didUpdateNearestCheckpoints checkpoints: [Checkpoint]) {
        nearestCheckpoints = checkpoints
    }
}
