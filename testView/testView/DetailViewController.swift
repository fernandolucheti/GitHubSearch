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


    var detailItem: AnyObject? {
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
        self.activityIndicator!.stopAnimating()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail["name"] as? String
            }
        }
    }
    var isForked = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        let net = NetworkController()
        var detailName = String()
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                detailName = detail["name"] as! String
            }
            if let forked: AnyObject = detail["fork"]{
                isForked = forked as! Bool
            }
        }
        
        commitsTextView.text = ""
        self.loading()
        
        dispatch_async(dispatch_get_main_queue()) {
            if detailName != ""{
                let commits = net.searchCommits(detailName)
                
                for var i = 0; i < commits.count; ++i{
                    
                    if let commit: AnyObject = commits.objectAtIndex(i)["commit"]{
                        if let author: AnyObject = commit["author"]{
                            if let authorName: AnyObject = author["name"]{
                                self.commitsTextView.insertText(authorName as! String)
                                self.commitsTextView.insertText("\n")
                            }
                        }
                        if let message: AnyObject = commit["message"]{
                            self.commitsTextView.insertText(message as! String)
                            self.commitsTextView.insertText("\n\n")
                        }
                    }
                    
                    
                }
                
                self.badgesLabel.text = "badges"
                if self.isForked{
                    let badges = net.searchBadges(detailName)
                    var text = ""
                    
                    var myMutableString = NSMutableAttributedString()
                    var initialPos = 0
                    
                    for var i = 0; i < badges.count; ++i{
                        let badge: Badge = badges.objectAtIndex(i) as! Badge
                        var name: NSString = badge.name
                        var color: UIColor = self.hexStringToUIColor(badge.color)
                        
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

