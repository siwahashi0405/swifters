//
//  ListViewController.swift
//  lunch
//
//  Created by 菅原 佑太 on 2017/07/23.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myUuid: String!
    var tag: Int!
    var lunchTypes: [Int: String] = [0: "indoor", 1: "outdoor"]
    var lists = [List]()
    
    @IBOutlet weak var outdoorBtn: UIImageView!
    @IBOutlet weak var patioBtn: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myUuid = UIDevice.current.identifierForVendor!.uuidString
        if self.tag == 1 {
            patioBtn.isHidden = true
            outdoorBtn.isHidden = false
        } else {
            patioBtn.isHidden = false
            outdoorBtn.isHidden = true
        }
        
        getUserLunchInfo()
    }
    
    func getUserLunchInfo() {
        // 現在日付
        let fmt = DateFormatter()
        let now = Date()
        fmt.dateFormat = "yyyy-MM-dd"
        let date = fmt.string(from: now)
        let ref = Database.database().reference()
        ref.child(date).child(self.lunchTypes[self.tag]!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? Dictionary<String, AnyObject>{
                self.lists = []
                for (_,value) in values {
                    let list = List()
                    list.nickname = value as? String
                    self.lists.append(list)
                }

                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }) { (error) in
            print("エラー")
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell", for: indexPath) as! ListViewCell
        cell.textLabel!.text = self.lists[indexPath.row].nickname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

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
