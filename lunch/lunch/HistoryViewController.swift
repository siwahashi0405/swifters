//
//  HistoryViewController.swift
//  lunch
//
//  Created by 菅原 佑太 on 2017/06/25.
//  Copyright © 2017年 swifters. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableview: UITableView!
    
    var myUuid: String!
    var histories: [Hisotry]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UUID
        self.myUuid = UIDevice.current.identifierForVendor!.uuidString
        
        let url = URL(string: "https://swiftershoge.herokuapp.com/index.php/history/\(myUuid! as String)")
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
                                
                                
                                history.title = name
                                history.url = url
                                history.imageUrl = urlToImage
                                if history.imageUrl == nil {
                                    history.imageUrl = "http://www.ntochi.jp/wp-content/themes/ntochi/images/noimage.gif?x67336"
                                }
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


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyViewCell", for: indexPath) as! HistoryViewCell
        
        if (self.histories?[indexPath.item].imageUrl?.isEmpty)! {
            self.histories?[indexPath.item].imageUrl = "https://swiftershoge.herokuapp.com/htdocs/img/destination.png"
        }
        
        cell.title.text = self.histories?[indexPath.item].title
        cell.imgView.downloadImage(from: (self.histories?[indexPath.item].imageUrl!)!)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories?.count ?? 0
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        //self.dismiss(animated: true, completion: nil)   // 戻る
        let UrlRequest = self.histories?[indexPath.item].url
        if let url = URL(string: UrlRequest!), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
extension UIImageView {
    
    func downloadImage(from url: String){

        let urlRequest = URLRequest(url: URL(string: url)!)

    print(url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

