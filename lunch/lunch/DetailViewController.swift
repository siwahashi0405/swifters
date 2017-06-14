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
        
        self.mapWebView.loadRequest(URLRequest(url: URL(string: "https://www.google.co.jp/maps/@35.6528617,139.7457934,13z")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
