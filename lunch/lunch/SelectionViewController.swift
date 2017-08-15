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
    var tag: Int!
    
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
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "listView")
        let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
        // uuidがすでに登録されていた場合
        ref.child(self.myUuid).observeSingleEvent(of: .value, with: { (snapshot) in
            //let value = snapshot.value as? NSDictionary
            //print(value?["user"])
            // 現在画面へ遷移
            self.navigationController?.popViewController(animated: true)
            }) { (error) in
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
                    // 一覧画面へ遷移
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
    }
    
    func senderList(sender:UIButton) {
        self.performSegue(withIdentifier: "listViewController", sender: self.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listViewController" {
            let listViewController = segue.destination as! ListViewController
            listViewController.tag = sender as? Int
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
