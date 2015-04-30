//
//  DetailViewController.swift
//  testView
//
//  Created by Fernando Lucheti on 27/04/15.
//  Copyright (c) 2015 Fernando Lucheti. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController {
    
    

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var badgesLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail["name"] as? String
            }
        }
    }

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
        }
        let badges = net.searchBadges(detailName)
        var text = ""
        
        
        
        var myMutableString = NSMutableAttributedString()
        
        

//        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia", size: 36.0)!, range: NSRange(location: 0, length: 1))
//        myMutableString.addAttribute(NSStrokeColorAttributeName, value: UIColor.blueColor(), range:  NSRange(location: 0, length: 1))
//        myMutableString.addAttribute(NSStrokeWidthAttributeName, value: 2, range: NSRange(location: 0, length: 1))
        
        //var initialPos:Int
        var initialPos = 0
        for var i = 0; i < badges.count; ++i{
            let badge: Badge = badges.objectAtIndex(i) as! Badge
            var name: NSString = badge.name
            var color: UIColor = hexStringToUIColor(badge.color)
            
            var c = NSMutableAttributedString(string: name as String, attributes: [NSFontAttributeName: self.badgesLabel.font!])
            myMutableString.appendAttributedString(c)
            myMutableString.appendAttributedString(NSAttributedString(string: (String("\n"))))
            myMutableString.addAttribute(NSBackgroundColorAttributeName, value: color, range:  NSRange(location: initialPos, length: name.length))
            initialPos += name.length + 1
            
        }
        
        self.badgesLabel.attributedText = myMutableString
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
    
    
    func setString(){
        
        var myMutableString = NSMutableAttributedString()
        var myString:NSString = "badge1 badge2 badge3"
        //Initialize the mutable string
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        
        //Add more attributes here:
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Chalkduster", size: 24.0)!, range: NSRange(location: 7,length: 5))
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "AmericanTypewriter-Bold", size: 18.0)!, range: NSRange(location:2,length:4))
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:2,length:4))
        
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia", size: 36.0)!, range: NSRange(location: 0, length: 1))
        myMutableString.addAttribute(NSStrokeColorAttributeName, value: UIColor.blueColor(), range:  NSRange(location: 0, length: 1))
        myMutableString.addAttribute(NSStrokeWidthAttributeName, value: 2, range: NSRange(location: 0, length: 1))
        
        myMutableString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 0, length: myString.length))
        //myLabel.backgroundColor = UIColor.grayColor()
        
        //Apply to the label
        //myLabel.attributedText = myMutableString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

