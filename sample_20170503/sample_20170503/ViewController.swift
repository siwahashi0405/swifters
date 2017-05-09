//
//  ViewController.swift
//  sample_20170503
//
//  Created by 岩橋 聡吾 on 2017/05/03.
//  Copyright © 2017年 岩橋 聡吾. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func history(_ sender: Any) {
        let listTableViewController = ListTableViewController()
        listTableViewController.list = [0 : "聡吾", 1 : "5678", 2 : "メロン"]
        self.present(listTableViewController, animated: true, completion: nil)
    }
}

