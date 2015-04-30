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
        for badge in badges {
            text = "\(text) \n \(badge)"
        }
        self.badgesLabel.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

