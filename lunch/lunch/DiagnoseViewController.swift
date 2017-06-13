//
//  DiagnoseView.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/06/12.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class DiagnoseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var spinner: UIImageView!

    //override func viewWillAppear() {
    override func viewWillAppear(_ animated: Bool) {
        print("DiagnoseViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * カメラの撮影開始
     */
    @IBAction func takePicture(_ sender: AnyObject) {
        print("takePicture")
        
        //        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
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
        //        print(info[UIImagePickerControllerEditedImage])
        if let image = info[UIImagePickerControllerOriginalImage] {
            print(image)
            self.cameraView.image = image as? UIImage
            self.spinner.image = UIImage.gif(name: "images/load")   // スピナー表示
            //            Image2String(image: cameraView.image!)   // Base64に変換
        }
        cameraPicker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.spinner.image = UIImage.gif(name: "")   // スピナー非表示
            print("2秒後")
            // 2秒後に実行したい処理
//            let detailViewController = UIStoryboard(name: "DetailViewControllerStoryboard", bundle: nil).instantiateInitialViewController()!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerStoryboard")
//            detailViewController.list = [0 : "聡吾", 1 : "5678", 2 : "メロン"]
            self.present(detailViewController, animated: true, completion: nil)
            print("3秒後")
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
    
}
