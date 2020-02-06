//
//  Session.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/27.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Session: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.download()
    }
    
    func download() {
        let imageAddress = "http://blog.tomasmahrik.com/wp-content/uploads/2015/06/swift.jpg"
        if let imageURL = URL(string: imageAddress) {
            APIManager.shared.fetchedDataByDataTask(from: URLRequest(url: imageURL)) { (data) in
                DispatchQueue.main.async {
                    let loadedImage = UIImage(data: data)
                    self.imageView.image = loadedImage
                }
            }
        }
    }

    @IBAction func getClick(_ sender: Any) {
        self.requestWithURL(urlString: "https://httpbin.org/get", parameters: ["para1":"value1", "para2":"value2"]) { (data) in
            DispatchQueue.main.async {
                self.textView.text = String(data: data, encoding: .utf8)
            }
        }
    }
    
    @IBAction func getHeaderClick(_ sender: Any) {
        self.requestWithHeader(urlString: "https://httpbin.org/get", parameters: ["header1":"value1", "header2":"value2"]) { (data) in
            DispatchQueue.main.async {
                self.textView.text = String(data: data, encoding: .utf8)
            }
        }
    }
    
    @IBAction func postJSONClick(_ sender: Any) {
        self.requestWithJSONBody(urlString: "https://httpbin.org/post", parameters: ["para1":"value1", "para2":"value2"]) { (data) in
            DispatchQueue.main.async {
                self.textView.text = String(data: data, encoding: .utf8)
            }
        }
    }
    
    @IBAction func postURLEncodedClick(_ sender: Any) {
        self.requestWithUrlencodedBody(urlString: "https://httpbin.org/post", parameters: "para1=value1&para2%5Bvalue21%5D=value22") { (data) in
            DispatchQueue.main.async {
                self.textView.text = String(data: data, encoding: .utf8)
            }
        }
    }
    
    @IBAction func postFromDataClick(_ sender: Any) {
        guard let image = UIImage(named: "channelLogo_small") else {
            return
        }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        self.requestWithFormData(urlString: "https://httpbin.org/post", parameters: ["para1":"value1"], dataPath: ["file": uploadData]) { (data) in
            DispatchQueue.main.async {
                self.textView.text = String(data: data, encoding: .utf8)
            }
        }
    }
    
    @IBAction func downloadClick(_ sender: Any) {
        APIManager.shared.downloadByDownloadTask(urlString: "https://upload.wikimedia.org/wikipedia/zh/thumb/d/d8/Mario_NSMBW.png/250px-Mario_NSMBW.png") { (data) in
            DispatchQueue.main.async {
                let loadedImage = UIImage(data: data)
                self.imageView.image = loadedImage
            }
        }
    }
    
    func requestWithURL(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void) {
        
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.queryItems = []
            
            for (key, value) in parameters{
                guard let value = value as? String else { return }
                urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            guard let queryedURL = urlComponents.url else { return }
            
            let request = URLRequest(url: queryedURL)
            
            APIManager.shared.fetchedDataByDataTask(from: request, completion: completion)
        }
    }
    
    func requestWithHeader(urlString: String, parameters: [String: String], completion: @escaping (Data) -> Void){
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            for (key, value) in parameters {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            APIManager.shared.fetchedDataByDataTask(from: request, completion: completion)
        }
    }
    
    func requestWithJSONBody(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void){
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            } catch let error {
                print(error)
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            APIManager.shared.fetchedDataByDataTask(from: request, completion: completion)
        }
    }
    
    func requestWithUrlencodedBody(urlString: String, parameters: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpBody = parameters.data(using: String.Encoding.utf8)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            APIManager.shared.fetchedDataByDataTask(from: request, completion: completion)
        }
    }
    
    func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let boundary = "Boundary+\(arc4random())\(arc4random())"
            var body = Data()
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            for (key, value) in parameters {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
            
            for (key, value) in dataPath {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n") //此處放入file name，以隨機數代替，可自行放入
                body.appendString(string: "Content-Type: image/png\r\n\r\n") //image/png 可改為其他檔案類型 ex:jpeg
                body.append(value)
                body.appendString(string: "\r\n")
            }
            
            body.appendString(string: "--\(boundary)--\r\n")
            request.httpBody = body
            
            APIManager.shared.fetchedDataByDataTask(from: request, completion: completion)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Data {
    mutating func appendString(string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}
