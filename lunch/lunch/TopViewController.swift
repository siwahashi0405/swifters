//
//  TopViewController.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/05/09.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class TopViewController: UIViewController {

    @IBOutlet var backgroundVideo: BackgroundVideo!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundVideo.createBackgroundVideo(name: "movies/Background", type: "mp4", alpha: 0.3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

