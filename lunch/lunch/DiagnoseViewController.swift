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

    var myLatitude: Double!

    var myLongitude: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.spinner.image = UIImage.gif(name: "images/load")   // スピナーセット
        self.spinner.isHidden = true   // スピナー非表示

        locationManager = CLLocationManager()   // インスタンスの生成
        locationManager.delegate = self   // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
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
        print("完了！")

        if let image = info[UIImagePickerControllerOriginalImage] {
            print(image)
            self.cameraView.image = image as? UIImage   // 写真セット
            self.cameraView.isHidden = false   // 写真表示
            self.message.isHidden = true   // メッセージ非表示
            self.spinner.isHidden = false   // スピナー表示
            self.takePictureBtn.isHidden = true   // ボタン非表示
//            Image2String(image: cameraView.image!)   // Base64に変換
        }
        cameraPicker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 2秒後に実行したい処理
            self.cameraView.isHidden = true   // 写真非表示
            self.message.isHidden = false   // メッセージ表示
            self.spinner.isHidden = true   // スピナー非表示
            self.takePictureBtn.isHidden = false   // ボタン表示
//            let detailViewController = UIStoryboard(name: "DetailViewControllerStoryboard", bundle: nil).instantiateInitialViewController()!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerStoryboard")
//            detailViewController.list = [0 : "聡吾", 1 : "5678", 2 : "メロン"]
            self.present(detailViewController, animated: true, completion: nil)
        }
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
            
            //            print(encodeString)
            return encodeString
            
        }
        
        return nil
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 取得許可を求める
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 取得許可を求める
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 取得許可を求める
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.startUpdatingLocation()
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        if location != nil {
            // 位置情報セット
            myLatitude = location?.coordinate.latitude
            myLongitude = location?.coordinate.longitude
            // 位置情報ストップ
            locationManager.stopUpdatingLocation()
        }
    }
}
