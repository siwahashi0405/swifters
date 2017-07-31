//
//  SelectionViewController.swift
//  lunch
//
//  Created by 菅原 佑太 on 2017/07/30.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit
import Firebase

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var alertbtn: UIButton!
    var myUuid: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myUuid = UIDevice.current.identifierForVendor!.uuidString

        alertbtn.setTitle("アラートボタン", for: .normal)
        alertbtn.setTitleColor(UIColor.blue, for: .normal)
        alertbtn.addTarget(self, action: #selector(self.showTextInputAlert), for: .touchUpInside)
        alertbtn.sizeToFit()
        alertbtn.center = self.view.center
        self.view.addSubview(alertbtn)
    }
    
    func showTextInputAlert() {
        // テキストフィールド付きアラート表示
        let alert = UIAlertController(title: "ニックネーム", message: "あなたのニックネームを入力してください。", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
            
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    print(textField.text!, self.myUuid)
                    ref.child(self.myUuid! as String).setValue(["user": textField.text!, "date": ServerValue.timestamp()])
                }
            }
            // 一覧へ遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "listView")
            
            self.present(nextView, animated: true, completion: nil)
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action:UIAlertAction!) -> Void in
            
            // キャンセルを押した時前の画面に遷移する
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(cancelAction)
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
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
