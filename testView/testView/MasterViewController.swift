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
    var yourRepos: NSMutableArray!
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
        
        //let notificationCenter = NSNotificationCenter.defaultCenter()
        //notificationCenter.addObserver(self, selector: "reloadData", name: "webDataReceived", object: nil)
        
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
            dispatch_async(dispatch_get_main_queue()) {
                self.yourRepos = networkController.searchYourRepo()
                self.repos = networkController.searchRepository()
                self.reloadData()
            }
            

        }
        
    }
    
    func loading(){
        
        if self.loadingView == nil{
            self.loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            self.loadingView?.center = CGPointMake(self.view.center.x, self.view.center.y)
            self.loadingView?.backgroundColor = UIColor.blackColor()
            self.loadingView?.alpha = 0.5
            
        }
        self.view.addSubview(self.loadingView!)
        if self.activityIndicator == nil {

            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            self.activityIndicator!.alpha = 1
            self.activityIndicator!.hidesWhenStopped = false
            self.activityIndicator!.center = CGPointMake(self.view.center.x, self.view.center.y)
            
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
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Meus repositorios"
        }else{
            return "Forked from MackMobile"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos == nil{
            repos = NSMutableArray()
        }
        if yourRepos == nil{
            yourRepos = NSMutableArray()
        }
        if section == 0 {
            return yourRepos.count
        }else{
            return repos.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.section == 0{
            cell.textLabel!.text = yourRepos.objectAtIndex(indexPath.row)["name"] as? String
        }else{
            cell.textLabel!.text = repos.objectAtIndex(indexPath.row)["name"] as? String
        }
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

