//
//  DetailViewController.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/06/13.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mapWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // MAP
        
        self.mapWebView.loadRequest(URLRequest(url: URL(string: "https://swiftershoge.herokuapp.com/index.php/map?destinationName=%E3%83%AC%E3%82%B9%E3%83%88%E3%83%A9%E3%83%B3%E5%90%8D&destinationLat=34.65&destinationLong=135.50&currentLat=34.6578&currentLong=135.5067")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
