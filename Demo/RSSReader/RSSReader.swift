//
//  RSSReader.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

struct NewsItem {
    var title: String?
    var link: String?
}

class RSSReader: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let apiAddress = "https://www.cnet.com/rss/news/"
    var objects = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.downloadNews()
    }
    
    func downloadNews() {
        if let url = URL(string: self.apiAddress) {
            APIManager.shared.fetchedDataByDataTask(from: URLRequest(url: url)) { (data) in
                let parser = XMLParser(data: data)
                let rssParserDelegate = RSSParserDelegate()
                parser.delegate = rssParserDelegate
                if parser.parse() {
                    self.objects = rssParserDelegate.getResult()
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                else {
                    print("parse fail")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RSSReader: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = objects[indexPath.row].title
        return cell
    }
}

extension RSSReader: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.link = self.objects[indexPath.row].link
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
