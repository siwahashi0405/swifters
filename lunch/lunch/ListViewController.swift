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
    
    var myUuid: String!
    var tag: Int!
    var lunchTypes: [Int: String] = [0: "indoor", 1: "outdoor"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myUuid = UIDevice.current.identifierForVendor!.uuidString
        // tag: 0:indoor 1:outdoor
        // save
        print(self.tag)
        getUserLunchInfo()
        
    }
    
    func getUserLunchInfo() {
        // 現在日付
        let fmt = DateFormatter()
        let now = Date()
        fmt.dateFormat = "yyyy-MM-dd"
        let date = fmt.string(from: now)
        let ref = Database.database().reference()
        self.tag = 0
        ref.child(date).child(self.lunchTypes[self.tag]!).observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? NSDictionary

            for (key,value) in values! {
                print("uuid: \(key), value: \(value)")
            }
        
            

        }) { (error) in
            print("エラー")
        }

    }
    
    // ランチをキーにして当日日付valueがなければ作成する
    // 日付を作成と同時にlunchtype(2種類作成する)
    
    // 今回選んだタイプのキーが一致すればその場所にユーザーID入れる

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
