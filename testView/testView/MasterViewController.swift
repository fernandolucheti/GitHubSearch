//
//  MasterViewController.swift
//  testView
//
//  Created by Fernando Lucheti on 27/04/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var repos: NSMutableArray!
    var yourRepos: NSMutableArray!
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
        
        if self.activityIndicator == nil {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            self.activityIndicator!.alpha = 1
            self.activityIndicator!.hidesWhenStopped = true
        }
        let activityItem = UIBarButtonItem(customView: self.activityIndicator!)
        self.navigationItem.rightBarButtonItem = activityItem
        self.activityIndicator!.startAnimating()
        
    }
    
    
    func finishedLoading(){
        self.activityIndicator!.stopAnimating()
    }
    
    
    func reloadData(){
        self.tableView.reloadData()
        self.finishedLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if indexPath.section == 0{
                    let object = yourRepos.objectAtIndex(indexPath.row) as! NSDictionary
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }else{
                    let object = repos.objectAtIndex(indexPath.row) as! NSDictionary
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
            case 0:
                return "Meus Repositórios"
            case 1:
                return "Pulls do MackMobile"
            default:
                return ""
        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos == nil{
            repos = NSMutableArray()
        }
        if yourRepos == nil{
            yourRepos = NSMutableArray()
        }
        switch section{
        case 0:
            return yourRepos.count
        case 1:
            return repos.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.section{
        case 0:
            cell.textLabel!.text = yourRepos.objectAtIndex(indexPath.row)["name"] as? String
        case 1:
            cell.textLabel!.text = repos.objectAtIndex(indexPath.row)["name"] as? String
        default:
            return cell
        }
        
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

}

