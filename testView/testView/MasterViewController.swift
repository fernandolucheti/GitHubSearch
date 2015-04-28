//
//  MasterViewController.swift
//  testView
//
//  Created by Fernando Lucheti on 27/04/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var repos: NSMutableArray!
    var loadingView: UIView?
    var activityIndicator: UIActivityIndicatorView?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "reloadData", name: "webDataReceived", object: nil)
        
        self.loading()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
            
            
            
            var networkController = NetworkController()
            //repos = networkController.searchForkedRepositories("mackmobile", yourName: "fernandolucheti")
            //repos = networkController.searchRepository("mackmobile")
            repos = networkController.searchRepository()
        }
        
    }
    func loading(){
        
        if loadingView == nil{
            loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            loadingView?.center = CGPointMake(self.view.center.x, self.view.center.y)
            loadingView?.backgroundColor = UIColor.blackColor()
            loadingView?.alpha = 0.5
            
        }
        self.view.addSubview(loadingView!)
        if activityIndicator == nil {

            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator!.alpha = 1
            activityIndicator!.hidesWhenStopped = false
            activityIndicator!.center = CGPointMake(self.view.center.x, self.view.center.y)
            
        }
        self.loadingView!.addSubview(activityIndicator!)
        self.activityIndicator!.startAnimating()
        
    }
    
    
    func finishedLoading(){
        self.loadingView?.removeFromSuperview()
        self.activityIndicator!.removeFromSuperview()
    }
    
    
    func reloadData(){
        self.tableView.reloadData()
        self.finishedLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = repos.objectAtIndex(indexPath.row) as! NSDictionary
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = repos.objectAtIndex(indexPath.row)["name"] as? String
        return cell
    }
    
    
    
    
    
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

