//
//  ListViewController.swift
//  lunch
//
//  Created by 菅原 佑太 on 2017/07/23.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {
    
    var tag: Int!
    var lunchTypes: [Int: String] = [0: "indoor", 1: "outdoor"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.tag)
        // tag: 0:indoor 1:outdoor
        //print(self.lunchTypes[self.tag!]!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
