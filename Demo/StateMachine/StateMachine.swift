//
//  StateMachine.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/3.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import GameplayKit

class ArticlesResponse: Codable {
    var status: String?
    var totalResults: Int
    var articles: [Article]?
}

class Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

class Source: Codable {
    var id: String?
    var name: String?
}

class ViewControllerState: GKState {
    
    // 用 unowned let 來防止循環持有。
    unowned let viewController: StateMachine
    
    // 用來存取 viewController.view 的捷徑。
    var view: UIView {
        viewController.view
    }
    
    init(viewController: StateMachine) {
        self.viewController = viewController
    }
}

class EmptyState: ViewControllerState {
    // 創造包含標籤與按鈕的 emptyView。
    // 設定按鈕的 target 為 self。
    // 用 private 把 emptyView 封裝起來。
    private lazy var emptyView: UIView = {
        let label = UILabel()
        label.text = "No Article"
        let button = UIButton(type: .system)
        button.setTitle("Load Articles", for: .normal)
        button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 按下載入按鈕時，呼叫 stateMachine 進入載入狀態。
    @objc func didPressButton(_ sender: UIButton) {
        stateMachine?.enter(LoadingState.self)
    }
    
    // 將 emptyView 加到 view 裡面。
    override func didEnter(from previousState: GKState?) {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // 在離開狀態之前，把 emptyView 從 View 階層移除。
    override func willExit(to nextState: GKState) {
        emptyView.removeFromSuperview()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == LoadingState.self
    }
}

class LoadingState: ViewControllerState {
    // 網路呼叫的錯誤。
    enum Error: Swift.Error {
        case noData
    }
    
    // 創造一個 UIActivityIndicatorView。
    private var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    
    override func didEnter(from previousState: GKState?) {
        
        // 把 indicatorView 顯示出來。
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        indicatorView.startAnimating()
        
        // 進行網路呼叫。
        // 請自行加上 API key。
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8a98e44bc4b34425ab2e0f71cc0b350b")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.sync {
                do {
                    if let error = error { throw error }
                    guard let data = data else { throw Error.noData }
                    let response = try JSONDecoder().decode(ArticlesResponse.self, from: data)
                    
                    // 成功拿到 articles 的話就交給 ArticlesState 並切換過去。
                    self?.stateMachine?.state(forClass: ArticlesState.self)?.articles = response.articles!
                    self?.stateMachine?.enter(ArticlesState.self)
                } catch {
                    
                    // 出錯的話就把 error 交給 ErrorState 去顯示。
                    self?.stateMachine?.state(forClass: ErrorState.self)?.error = error
                    self?.stateMachine?.enter(ErrorState.self)
                }
            }
        }
        task.resume()
    }
    
    // 清理狀態。
    override func willExit(to nextState: GKState) {
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ArticlesState.self || stateClass == ErrorState.self
    }
}

// UITableViewDataSource 所用。
private let cellReuseIdentifier = "Cell"
class ArticlesState: ViewControllerState {
    // 持有 articles。
    var articles = [Article]()
    
    // 創造一個 UITableView。
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // 將 tableView 顯示出來。
    override func didEnter(from previousState: GKState?) {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.reloadData()
    }
    
    // 移除 tableView。
    override func willExit(to nextState: GKState) {
        tableView.removeFromSuperview()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EmptyState.self
    }
}

// 實作 UITableViewDataSource。
extension ArticlesState: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        return cell
    }
}

// 實作 UITableViewDelegate。
extension ArticlesState: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            .init(style: .destructive, title: "Delete") { [weak self] action, sourceView, completion in
                guard let self = self else { completion(false); return }
                
                // 刪除條目。
                self.articles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                
                // 如果沒有剩下條目的話，就進入到空白狀態。
                if self.articles.isEmpty {
                    self.stateMachine?.enter(EmptyState.self)
                }
                
                completion(true)
            }
        ])
    }
}

class ErrorState: ViewControllerState {
    // 將要顯示的 Error。
    var error: Error?
    
    // 顯示中的 alertController。
    var alertController: UIAlertController?
    
    // 呈現一個 UIAlertController。
    override func didEnter(from previousState: GKState?) {
        
        guard let error = error else { return }
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.alertController = alertController
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] action in
            
            // 如果選擇取消的話，進到空白狀態。
            self?.stateMachine?.enter(EmptyState.self)
        }
        alertController.addAction(dismissAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] action in
            
            // 如果選擇重試的話，進到載入中狀態。
            self?.stateMachine?.enter(LoadingState.self)
        }
        alertController.addAction(retryAction)
        
        viewController.present(alertController, animated: true)
    }
    
    // 以防 alertController 還沒被去除掉。
    override func willExit(to nextState: GKState) {
        if alertController != nil, alertController === viewController.presentedViewController {
            viewController.dismiss(animated: true)
        }
        alertController = nil
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EmptyState.self || stateClass == LoadingState.self
    }
}

class StateMachine: UIViewController {
    
    var stateMachine: GKStateMachine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // 狀態機初始化之後就不能增減狀態了，所以要在這邊把全部的狀態建構好再拿來建構狀態機。
        stateMachine = GKStateMachine(states: [
            ErrorState(viewController: self),
            EmptyState(viewController: self),
            LoadingState(viewController: self),
            ArticlesState(viewController: self)
        ])
        
        // 要狀態機先進入空白狀態。
        stateMachine?.enter(EmptyState.self)
    }
    
}
