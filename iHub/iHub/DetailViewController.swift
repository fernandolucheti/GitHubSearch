//
//  DetailViewController.swift
//  testView
//
//  Created by Fernando Lucheti on 27/04/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var commitsTextView: UITextView!
    
    var addButton: UIBarButtonItem!
    
    var detailName: String!
    var counterForFinishLoading = 0
    
    var repository: Repository? {
        didSet {
            // Update the view.
            self.configureView()
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
        if counterForFinishLoading > 1{
            self.activityIndicator!.stopAnimating()
            self.navigationItem.rightBarButtonItem = addButton
        }
        
    }
    
    func getCommitsFromLocalStore(){
        var commits = repository!.commits.allObjects
        var initialPos = 0
        var myMutableString = NSMutableAttributedString()
        for var i = 0; i < commits.count; ++i{
            var commit = commits[i] as! Commit
            //self.commitsTextView.insertText(commit.owner)
            //self.commitsTextView.insertText("\n")
            //self.commitsTextView.insertText(commit.descriptionText)
            //self.commitsTextView.insertText("\n\n")
            

                
            var owner: NSString = commit.owner
            var description: NSString = commit.descriptionText
            
            var ownerName = NSMutableAttributedString(string: owner as String, attributes: [NSFontAttributeName: self.commitsTextView.font!])
            myMutableString.appendAttributedString(ownerName)
            myMutableString.appendAttributedString(NSAttributedString(string: (String("\n"))))
            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "AmericanTypewriter-Bold", size: 14.0)!, range: NSRange(location: initialPos, length: ownerName.length + 1))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range:  NSRange(location: initialPos, length: owner.length))
            initialPos += owner.length + 1
            
            
            
            var descriptText = NSMutableAttributedString(string: description as String, attributes: [NSFontAttributeName: self.commitsTextView.font!])
            myMutableString.appendAttributedString(descriptText)
            myMutableString.appendAttributedString(NSAttributedString(string: (String("\n\n"))))
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range:  NSRange(location: initialPos, length: descriptText.length))
            initialPos += descriptText.length + 2
            
                
                if myMutableString.string != ""{
                    self.commitsTextView.attributedText = myMutableString
                }
                
            
        }
    }
    
    func getBadgesFromLocalStore(){
        var badges = repository!.badges.allObjects
        var myMutableString = NSMutableAttributedString()
        var initialPos = 0
        for var i = 0; i < badges.count; ++i{
            var badge = badges[i] as! Badge
            
            var name: NSString = badge.name
            var color: UIColor = self.hexStringToUIColor(badge.color)
            
            
            var c = NSMutableAttributedString(string: name as String, attributes: [NSFontAttributeName: self.badgesLabel.font!])
            myMutableString.appendAttributedString(c)
            myMutableString.appendAttributedString(NSAttributedString(string: (String("\n"))))
            myMutableString.addAttribute(NSBackgroundColorAttributeName, value: color, range:  NSRange(location: initialPos, length: name.length))
            initialPos += name.length + 1
            
        
        if myMutableString.string != ""{
            self.badgesLabel.attributedText = myMutableString
        }
        
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Repository = self.repository {
            if let label = self.detailDescriptionLabel {
                label.text = detail.name
            }
        }
    }
    var isForked = 0
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    func refresh(){
        commitsTextView.text = ""
        badgesLabel.text = "Badges"
        counterForFinishLoading = 0
        self.loading()
        searchCommits()
        
        
        if isForked == 1{
            self.loading()
            searchBadges()
        }else{
            counterForFinishLoading++
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        self.navigationItem.rightBarButtonItem = addButton
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        let net = NetworkController()
        detailName = String()
        if let detail: Repository = self.repository {
            if let label = self.detailDescriptionLabel {
                detailName = detail.name
            }
                isForked = Int(detail.forked)
        }
        

        commitsTextView.text = ""
        
        
        
        
        if repository!.commits.allObjects.count > 0 {
            getCommitsFromLocalStore()
        }else{
            self.loading()
            
            searchCommits()
        }
        
        if repository!.badges.allObjects.count > 0{
            getBadgesFromLocalStore()
            counterForFinishLoading++
        }else{
            if isForked == 1{
                self.loading()
                searchBadges()
            }else{
                counterForFinishLoading++
            }
            
        }
        
        
    }
    
    func searchCommits(){
        CommitManager.sharedInstance.removeCommitFrom(self.repository!.name)
        let net = NetworkController()
        dispatch_async(dispatch_get_main_queue()) {
            if self.detailName != ""{
                let commits = net.searchCommits(self.detailName)

                
                for var i = 0; i < commits.count; ++i{
                    
                    
                    var autName = String()
                    var commitMessage = String()
                    
                    if let commit: AnyObject = commits.objectAtIndex(i)["commit"]{
                        if let author: AnyObject = commit["author"]{
                            if let authorName: AnyObject = author["name"]{
                                
                                autName = authorName as! String
                                //self.commitsTextView.insertText(authorName as! String)
                                //self.commitsTextView.insertText("\n")
                            }
                        }
                        if let message: AnyObject = commit["message"]{
                            commitMessage = message as! String
                            //self.commitsTextView.insertText(message as! String)
                            //self.commitsTextView.insertText("\n\n")
                        }
                    }
                    
                    
                    
                    if autName != "" && commitMessage != ""{
                        

                            var commitx = CommitManager.sharedInstance.newCommit()
                            commitx.owner = autName
                            commitx.descriptionText = commitMessage
                            commitx.repository = self.repository!
                        
                            CommitManager.sharedInstance.save()
                            
                        
                    }
                    
                    
                }
                
                
            }
            self.getCommitsFromLocalStore()
            self.counterForFinishLoading++
            self.finishedLoading()
        }

    }
    
    func searchBadges(){
        let net = NetworkController()
        dispatch_async(dispatch_get_main_queue()) {
            if self.detailName != ""{
                if self.isForked == 1{
                    
                    
                    let badges = net.searchBadges(self.detailName)
                    var text = ""
                    
                    var myMutableString = NSMutableAttributedString()
                    var initialPos = 0
                    
                    for var i = 0; i < badges.count; ++i{
                        let badge: Badge = badges.objectAtIndex(i) as! Badge
                        var name: NSString = badge.name
                        var color: UIColor = self.hexStringToUIColor(badge.color)
                        
                        
                        var badgex = BadgeManager.sharedInstance.newBadge()
                        badgex = badges.objectAtIndex(i) as! Badge
                        badgex.repository = self.repository!
                        BadgeManager.sharedInstance.save()
                        
                        var c = NSMutableAttributedString(string: name as String, attributes: [NSFontAttributeName: self.badgesLabel.font!])
                        myMutableString.appendAttributedString(c)
                        myMutableString.appendAttributedString(NSAttributedString(string: (String("\n"))))
                        myMutableString.addAttribute(NSBackgroundColorAttributeName, value: color, range:  NSRange(location: initialPos, length: name.length))
                        initialPos += name.length + 1
                        
                    }
                    if myMutableString.string != ""{
                        self.badgesLabel.attributedText = myMutableString
                    }
                }
            }
            self.counterForFinishLoading++
            self.finishedLoading()
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

