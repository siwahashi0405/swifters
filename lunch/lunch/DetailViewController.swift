//
//  DetailViewController.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/06/13.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var restaurantName: String!
    
    var restaurantUrlMobile: URL!

    var restaurantImageUrl: URL!

    var restaurantLat: Double!

    var restaurantLong: Double!

    var currentLat: Double!

    var currentLong: Double!

    @IBOutlet weak var mapWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // MAP
        let mapUrl = "https://swiftershoge.herokuapp.com/index.php/map" +
                     "?destinationName=\(restaurantName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! as String)" +
                     "&destinationLat=\(String(restaurantLat))" +
                     "&destinationLong=\(String(restaurantLong))" +
                     "&currentLat=\(String(currentLat))" +
                     "&currentLong=\(String(currentLat))"
        print("mapUrl:" + mapUrl)
        self.mapWebView.loadRequest(URLRequest(url: URL(string: mapUrl)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
