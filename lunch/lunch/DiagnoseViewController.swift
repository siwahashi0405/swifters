//
//  DiagnoseView.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/06/12.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import CoreLocation

class DiagnoseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cameraView: UIImageView!

    @IBOutlet weak var message: UILabel!

    @IBOutlet weak var spinner: UIImageView!

    @IBOutlet weak var takePictureBtn: UIButton!

    var locationManager: CLLocationManager!

    var currentLat: Double! = 35.664342

    var currentLong: Double! = 139.714222
    
    var myUuid: String!
    
    var imageBase64: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // スピナー
        self.spinner.image = UIImage.gif(name: "images/load")   // スピナーセット
        self.spinner.isHidden = true   // スピナー非表示
        // 位置情報取得手続き
        self.locationManager = CLLocationManager()   // インスタンスの生成
        self.locationManager.delegate = self   // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        // UUID
        self.myUuid = UIDevice.current.identifierForVendor!.uuidString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * カメラの撮影開始
     */
    @IBAction func takePicture(_ sender: AnyObject) {
        print("run take picture")
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.cameraDevice = .front
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("error")
        }
    }

    /**
     * 撮影が完了時した時に呼ばれる
     */
    func imagePickerController(_ cameraPicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("take picture complete！")

        if let image = info[UIImagePickerControllerOriginalImage] {
            print(image)
            self.cameraView.image = image as? UIImage   // 写真セット
            self.cameraView.isHidden = false   // 写真表示
            self.message.isHidden = true   // メッセージ非表示
            self.spinner.isHidden = false   // スピナー表示
            self.takePictureBtn.isHidden = true   // ボタン非表示
            self.imageBase64 = Image2String(image: self.cameraView.image!)   // Base64に変換
        }
        cameraPicker.dismiss(animated: true, completion: nil)
        
        // apiデータ取得
        let apiUrl = "https://swiftershoge.herokuapp.com/index.php/face"
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        let postString = "uuid=\(myUuid! as String)&image_base64=\(imageBase64! as String)&user_latitude=\(String(currentLat))&user_longitude=\(String(currentLong))"
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            DispatchQueue.main.async {
                do {
                    if (error == nil) {
                        // 取得成功
                        // JSON解析
                        let apiData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        print(apiData)
                        // 評価
                        if apiData["result"] as! Int == 0 {
                            //// 正常：レストラン取得
                            print("正常：レストラン取得")
                            self.resetCamera()
                            let restaurant = apiData["restaurant"] as! [String:AnyObject]   // レストラン取得

                            // 値渡し
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerStoryboard") as! DetailViewController
                            detailViewController.comment = apiData["comment"] as! String
                            detailViewController.restaurantName = restaurant["name"] as! String
                            if restaurant["pr"]!["pr_short"] is NSNull {
                                detailViewController.pr = "swiftersオススメ！！！"
                            } else {
                                detailViewController.pr = restaurant["pr"]!["pr_short"] as! String
                            }
                            detailViewController.restaurantUrlMobile = URL(string: restaurant["url_mobile"] as! String)
                            if restaurant["image_url"]!["shop_image1"] is NSNull {
                                detailViewController.restaurantImageUrl = URL(string: "http://is2.mzstatic.com/image/thumb/Purple111/v4/e8/a4/35/e8a4357f-465e-8099-b8f7-e31695411c73/source/1200x630bb.jpg")
                            } else {
                                detailViewController.restaurantImageUrl = URL(string: restaurant["image_url"]!["shop_image1"] as! String)
                            }
                            detailViewController.restaurantLat = (restaurant["latitude"] as! NSString).doubleValue
                            detailViewController.restaurantLong = (restaurant["longitude"] as! NSString).doubleValue
                            detailViewController.currentLat = self.currentLat
                            detailViewController.currentLong = self.currentLong
                            self.present(detailViewController, animated: true, completion: nil)

                        } else if apiData["result"] as! Int == 1 {
                            //// 正常：顔の検出できず
                            print("正常：顔の検出できず")
                            self.resetCamera()
                            /// アラート
                            // アラートを作成
                            let alert = UIAlertController(
                                title: "LUNCHからあなたへ",
                                message: "表情がうまく検出できませんでした。もう一度表情を撮影してください！",
                                preferredStyle: .alert)
                            // アラートにボタンをつける
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            // アラート表示
                            self.present(alert, animated: true, completion: nil)
                            
                        } else if apiData["result"] as! Int == 2 {
                            //// 正常：レストランなし
                            print("正常：レストランなし")
                            self.resetCamera()
                            /// アラート
                            // アラートを作成
                            let alert = UIAlertController(
                                title: "LUNCHからあなたへ",
                                message: "近くにレストランがありませんでした。少し移動してからまた試してください！",
                                preferredStyle: .alert)
                            // アラートにボタンをつける
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            // アラート表示
                            self.present(alert, animated: true, completion: nil)
                            
                        } else if apiData["result"] as! Int == 901 {
                            //// 異常：パラメーター不足
                            print("異常：パラメーター不足")
                            self.resetCamera()
                            /// アラート
                            // アラートを作成
                            let alert = UIAlertController(
                                title: "LUNCHからあなたへ",
                                message: "上手く通信できませんでした。もう一度表情を撮影してください！",
                                preferredStyle: .alert)
                            // アラートにボタンをつける
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            // アラート表示
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    } else {
                        // 取得失敗
                        print("could not get api data")
                        print(error!.localizedDescription)
                    }
                    
                    
                } catch {
                    // 取得失敗
                    print("error occured")
                }
            }
        })
        task.resume()
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     * UIImageをBase64形式に変換する
     */
    func Image2String(image: UIImage) -> String? {
        
        //画像をNSDataに変換 -> NSDataへの変換が成功していたら
        if let data = UIImagePNGRepresentation(image) {
            
            //BASE64のStringに変換する
            let encodeString: String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)

            return encodeString
            
        }
        
        return nil
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 取得許可を求める
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 取得許可を求める
            //self.locationManager.requestWhenInUseAuthorization()
            /// アラート
            // アラートを作成
            let alert = UIAlertController(
                title: "LUNCHからあなたへ",
                message: "ローケーションサービスの設定が「無効」になっています。「設定」より「LUNCH」アプリへのロケーションサービスを許可してください。",
                preferredStyle: .alert)
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            // アラート表示
            self.dismiss(animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 取得許可を求める
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            self.locationManager.startUpdatingLocation()
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        if location != nil {
            // 位置情報セット
            self.currentLat = location?.coordinate.latitude
            self.currentLong = location?.coordinate.longitude
            // 位置情報取得ストップ
            self.locationManager.stopUpdatingLocation()
        }
    }

    func resetCamera() {
        self.cameraView.isHidden = true   // 写真非表示
        self.message.isHidden = false   // メッセージ表示
        self.spinner.isHidden = true   // スピナー非表示
        self.takePictureBtn.isHidden = false   // ボタン表示
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
