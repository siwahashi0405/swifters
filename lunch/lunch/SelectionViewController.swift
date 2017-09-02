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
    
    var myUuid: String!
    var lunchTypes: [Int: String] = [0: "indoor", 1: "outdoor"]
    
    @IBOutlet weak var ptbtn: UIButton!
    @IBOutlet weak var outbtn: UIButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.myUuid = UIDevice.current.identifierForVendor!.uuidString
        
        ptbtn.addTarget(self, action: #selector(self.senderList), for: .touchUpInside)
        
        outbtn.addTarget(self, action: #selector(self.senderList), for: .touchUpInside)
        
        showTextInputAlert()
    }
    
    func showTextInputAlert() {
        let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
        // uuidがすでに登録されていた場合
        ref.child(self.myUuid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("user"){
                // 現在画面へ遷移
                self.navigationController?.popViewController(animated: true)
            }else{
                // テキストフィールド付きアラート表示
                let alert = UIAlertController(title: "ニックネーム", message: "あなたのニックネームを入力してください。", preferredStyle: .alert)
                
                // OKボタンの設定
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    (action:UIAlertAction!) -> Void in
                    // OKを押した時入力されていたテキストを表示
                    if let textFields = alert.textFields {
                        // アラートに含まれるすべてのテキストフィールドを調べる
                        for textField in textFields {
                            print(textField.text!, self.myUuid)
                            // firebaseにデータを入れる
                            ref.child(self.myUuid! as String).setValue(["user": textField.text!, "date": ServerValue.timestamp()])
                        }
                    }
                    // 現在画面へ遷移
                    self.navigationController?.popViewController(animated: true)
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
        }) { (error) in
                print("error")
        }
    }
    
    func senderList(sender:UIButton) {
        // 現在日付
        let fmt = DateFormatter()
        let now = Date()
        fmt.dateFormat = "yyyy-MM-dd"
        let date = fmt.string(from: now)
        let ref = Database.database().reference()
        // firebaseにユーザのランチ選択情報のデータを入れる
        ref.child(self.myUuid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            ref.child(date).child(self.lunchTypes[sender.tag]!).child("test").setValue(value?["user"])
        

        let storyboard: UIStoryboard = self.storyboard!
        let listView = storyboard.instantiateViewController(withIdentifier: "listView") as! ListViewController
            listView.tag = sender.tag
  
        // 一覧画面へ遷移
        self.present(listView, animated: true, completion: nil)
            }) { (error) in
            print("エラー")
        }
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
