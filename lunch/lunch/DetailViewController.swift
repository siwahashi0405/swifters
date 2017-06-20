//
//  DetailViewController.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/06/13.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var comment: String!

    var restaurantName: String!

    var pr: String!

    var restaurantUrlMobile: URL!

    var restaurantImageUrl: URL!

    var restaurantLat: Double!

    var restaurantLong: Double!

    var currentLat: Double!

    var currentLong: Double!

    @IBOutlet var commentLabel: UILabel!

    @IBOutlet var restaurantNameLabel: UILabel!

    @IBOutlet var prLabel: UILabel!

    @IBOutlet var restaurantImageView: UIImageView!

    @IBOutlet weak var mapWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // コメント
        self.commentLabel.text = self.comment + "あなたに！"
        // レストラン名
        self.restaurantNameLabel.text = self.restaurantName
        // PR
        self.prLabel.text = self.pr
        // レストラン画像
        let imageData = try? Data(contentsOf: restaurantImageUrl!)
        let image = UIImage(data:imageData!)
        self.restaurantImageView.image = image
        // MAP
        let mapUrl = "https://swiftershoge.herokuapp.com/index.php/map" +
                     "?destinationName=\(restaurantName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! as String)" +
                     "&destinationLat=\(String(restaurantLat))" +
                     "&destinationLong=\(String(restaurantLong))" +
                     "&currentLat=\(String(currentLat))" +
                     "&currentLong=\(String(currentLong))"
        print("mapUrl:" + mapUrl)
        self.mapWebView.loadRequest(URLRequest(url: URL(string: mapUrl)!))

        // タップ（レストラン）について
        // シングルタップ
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.tap(_:)))
        // デリゲートをセット
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        self.restaurantNameLabel.addGestureRecognizer(tapGesture)
        self.restaurantNameLabel.isUserInteractionEnabled = true
        self.prLabel.addGestureRecognizer(tapGesture)
        self.prLabel.isUserInteractionEnabled = true
        self.restaurantImageView.addGestureRecognizer(tapGesture)
        self.restaurantImageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // タップ（レストラン）イベント.
    func tap(_ sender: UITapGestureRecognizer){
        // safariブラウザを起動する
        let app = UIApplication.shared
        app.openURL(restaurantUrlMobile)
    }

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
