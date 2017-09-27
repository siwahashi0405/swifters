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

    var backgroundVideoView: BackgroundVideo!

    @IBOutlet var titleView: UIImageView!

    @IBOutlet var diagnoseBtn: UIButton!

    @IBOutlet var historyBtn: UIButton!
    
    @IBOutlet var goLunchBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 表示できる限界(bound)のサイズ
        let BoundSize_w: CGFloat = UIScreen.main.bounds.width //横幅
        let BoundSize_h: CGFloat = UIScreen.main.bounds.height //縦幅
        
        let i = arc4random_uniform(7) + 1   // 1〜7で乱数を発生
        backgroundVideoView = BackgroundVideo(frame: CGRect(x: 0, y: 0, width: BoundSize_w, height: BoundSize_h))
        backgroundVideoView.createBackgroundVideo(name: "movies/Background_" + String(i), type: "mp4", alpha: 0.3)

        backgroundVideoView.addSubview(titleView)
        backgroundVideoView.addSubview(diagnoseBtn)
        backgroundVideoView.addSubview(historyBtn)
        backgroundVideoView.addSubview(goLunchBtn)

        self.view.addSubview(backgroundVideoView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        // メモリリーク防止の為 全てのビューをクリア
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        backgroundVideoView = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
