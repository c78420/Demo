//
//  APIManager.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class APIManager:NSObject {
    static let shared = APIManager()
    
    var navigationController: UINavigationController? = UINavigationController()
    var downloadCompletionBlock: ((_ data: Data) -> Void)?
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = (error as NSError?) {
                var errorTitle = ""
                let errorCode = error.code
                if errorCode == -1009 {
                    errorTitle = "No internet connection"
                }
                else {
                    errorTitle = "Sorry"
                }
                DispatchQueue.main.async {
                    self.popAlert(title: errorTitle)
                }
                return
            } else {
                guard let data = data else{return}
                completion(data)
            }
        }
        task.resume()
    }
    
    func downloadByDownloadTask(urlString: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let configiguration = URLSessionConfiguration.default
            configiguration.timeoutIntervalForRequest = .infinity
            
            let urlSession = URLSession(configuration: configiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            let task = urlSession.downloadTask(with: request)
            
            downloadCompletionBlock = completion
            
            task.resume()
        }
    }
    
    func popAlert(title: String) {
        let alert = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.viewControllers.last?.present(alert, animated: true, completion: nil)
    }
}

extension APIManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = try! Data(contentsOf: location)
        if let block = downloadCompletionBlock {
            block(data)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
    }
    
}
