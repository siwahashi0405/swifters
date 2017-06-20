//
//  File.swift
//  lunch
//
//  Created by 岩橋 聡吾 on 2017/06/12.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController{
    
    
    @IBOutlet var tableview: UITableView!
    
    var histories: [Hisotry]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://swiftershoge.herokuapp.com/index.php/history/1")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print("ERROR")
            }
            else
            {
                // Historyswift
                self.histories = [Hisotry]()
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]

                    if let historiesFromJson = json["restaurant"] as? [[String : AnyObject]] {
                        for historyFromJson in historiesFromJson {
                            let history = Hisotry()
                            if let name = historyFromJson["name"] as? String, let url = historyFromJson["url_mobile"] as? String, let urlToImage = historyFromJson["image_url"] as? String {
                                
                                history.name = name
                                history.url = url
                                history.imageUrl = urlToImage
                            }
                            self.histories?.append(history)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            
        }
        task.resume()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    /**
     * セルの個数を指定するデリゲートメソッド（必須）
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(self.histories?.count)
        return self.histories?.count ?? 0
    }
    
    /**
     * セルに値を設定するデータソースメソッド（必須）
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell() //tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        // Configure the cell...
        cell.textLabel?.text = self.histories?[indexPath.item].name //list[indexPath[1]] as! String
        //cell.title.text = "test"
        
        return cell
    }
    
    /**
     * Cell が選択された場合
     */
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        //self.dismiss(animated: true, completion: nil)   // 戻る
        var UrlRequest = self.histories?[indexPath.item].url
        if let url = URL(string: UrlRequest!), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
