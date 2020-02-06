//
//  RandomUser.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/30.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

struct User {
    var name:String?
    var email:String?
    var number:String?
    var image:String?
}

struct AllData: Decodable {
    var results: [SingleData]?
}

struct SingleData: Decodable {
    var name: Name?
    var email: String?
    var phone: String?
    var picture: Picture?
}

struct Name: Decodable {
    var first: String?
    var last: String?
}

struct Picture: Decodable {
    var large: String?
}

class RandomUser: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var infoTableViewController: InfoTableViewController?
    
    let apiAddress = "https://randomuser.me/api/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "RandomUser"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.67, green: 0.2, blue: 0.157, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(sender:)))
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.downloadInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        self.userImage.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = self.view.tintColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            self.infoTableViewController = segue.destination as? InfoTableViewController
        }
    }
    
    func downloadInfo() {
        if let url = URL(string: self.apiAddress) {
            APIManager.shared.fetchedDataByDataTask(from: URLRequest(url: url)) { (data) in
                do {
                    let okData = try JSONDecoder().decode(AllData.self, from: data)
                    if let result = okData.results?[0] {
                        let user = User(name: self.userFullName(firstName: result.name?.first, lastName: result.name?.last), email: result.email, number: result.phone, image: result.picture?.large)
                        
                        DispatchQueue.main.async {
                            self.settingInfo(user: user)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        APIManager.shared.popAlert(title: "Sorry")
                    }
                }
            }
        }
    }
    
    func userFullName(firstName: String?, lastName: String?) -> String? {
        guard let first = firstName else {
            return nil
        }
        guard let last = lastName else {
            return nil
        }
        
        return first + " " + last
    }
    
    func settingInfo(user: User) {
        if let imageAddress = user.image, let imageURL = URL(string: imageAddress) {
            APIManager.shared.fetchedDataByDataTask(from: URLRequest(url: imageURL)) { (data) in
                DispatchQueue.main.async {
                    self.userImage.image = UIImage(data: data)
                    self.userName.text = user.name
                    self.infoTableViewController?.phoneLabel.text = user.number
                    self.infoTableViewController?.emailLabel.text = user.email
                }
            }
        }
    }
    
    @objc func refresh(sender: UIBarButtonItem) {
        self.downloadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
