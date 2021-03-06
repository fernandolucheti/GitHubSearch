//
//  MasterViewController.swift
//  iHub
//
//  Created by Fernando Lucheti on 02/05/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, UITableViewDataSource {

    var detailViewController: DetailViewController? = nil
    lazy var repositories:Array<Repository> = {
    return RepositoryManager.sharedInstance.findRepositories()
    }()
    var addButton: UIBarButtonItem!
    var repos: NSMutableArray!
    var yourRepos: NSMutableArray!
    var forkedRepos: NSMutableArray!
    var activityIndicator: UIActivityIndicatorView?
    var loadingView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    func splitRepositories(){
        
        if yourRepos == nil{
            yourRepos = NSMutableArray()
        }
        
        if forkedRepos == nil{
            forkedRepos = NSMutableArray()
        }
        
        
        for var i = 0; i < repositories.count; ++i{
            var rep = repositories[i] as! Repository
            if rep.name != ""{
                var n: NSNumber = 0
                if rep.forked as Int == 0{
                    yourRepos.addObject(rep)
                }else{
                     forkedRepos.addObject(rep)
                }
            }
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        repositories = RepositoryManager.sharedInstance.findRepositories()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        addButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "loadRepositories")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
            self.splitRepositories()
            loadRepositories()

        }
    }
    
    func loadRepositories(){
        
        self.loading()
        
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var networkController = NetworkController()
            
            networkController.searchYourRepo()
            self.yourRepos = NSMutableArray()
            self.forkedRepos = NSMutableArray()
            self.repositories = RepositoryManager.sharedInstance.findRepositories()
            self.splitRepositories()
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.finishedLoading()
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
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            self.activityIndicator!.alpha = 1
            self.activityIndicator!.hidesWhenStopped = true
        }
        let activityItem = UIBarButtonItem(customView: self.activityIndicator!)
        self.navigationItem.leftBarButtonItem = activityItem
        self.activityIndicator!.startAnimating()
        
    }
    
    
    func finishedLoading(){
        self.loadingView?.removeFromSuperview()
        self.activityIndicator!.stopAnimating()

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
                    let object = yourRepos[indexPath.row] as! Repository
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.repository = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }else{
                    let object = forkedRepos[indexPath.row] as! Repository
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.repository = object
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
        if forkedRepos == nil{
            forkedRepos = NSMutableArray()
        }
        if yourRepos == nil{
            yourRepos = NSMutableArray()
        }
        switch section{
        case 0:
            return yourRepos.count
        case 1:
            return forkedRepos.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.section{
        case 0:
            let repo = yourRepos.objectAtIndex(indexPath.row) as! Repository
            cell.textLabel!.text = repo.name
        case 1:
            let repo = forkedRepos.objectAtIndex(indexPath.row) as! Repository
            cell.textLabel!.text = repo.name
        default:
            return cell
        }
        
        
        return cell
    }
    

    

//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            let context = self.fetchedResultsController.managedObjectContext
//            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
//                
//            var error: NSError? = nil
//            if !context.save(&error) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                //println("Unresolved error \(error), \(error.userInfo)")
//                abort()
//            }
//        }
//    }

//    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
//            let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
//        cell.textLabel!.text = object.valueForKey("timeStamp")!.description
//    }

    // MARK: - Fetched results controller
//
//    var fetchedResultsController: NSFetchedResultsController {
//        if _fetchedResultsController != nil {
//            return _fetchedResultsController!
//        }
//        
//        let fetchRequest = NSFetchRequest()
//        // Edit the entity name as appropriate.
//        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
//        fetchRequest.entity = entity
//        
//        // Set the batch size to a suitable number.
//        fetchRequest.fetchBatchSize = 20
//        
//        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
//        let sortDescriptors = [sortDescriptor]
//        
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
//        aFetchedResultsController.delegate = self
//        _fetchedResultsController = aFetchedResultsController
//        
//    	var error: NSError? = nil
//    	if !_fetchedResultsController!.performFetch(&error) {
//    	     // Replace this implementation with code to handle the error appropriately.
//    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//             //println("Unresolved error \(error), \(error.userInfo)")
//    	     abort()
//    	}
//        
//        return _fetchedResultsController!
//    }    
//    var _fetchedResultsController: NSFetchedResultsController? = nil
//
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        self.tableView.beginUpdates()
//    }
//
//    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        switch type {
//            case .Insert:
//                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//            case .Delete:
//                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//            default:
//                return
//        }
//    }
//
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        switch type {
//            case .Insert:
//                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//            case .Delete:
//                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//            case .Update:
//                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
//            case .Move:
//                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
//                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
//            default:
//                return
//        }
//    }
//
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        self.tableView.endUpdates()
//    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

