//
//  Presenter.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/22.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

protocol MVPProtocol: class {
    func apiOnError(message: String?)
    func reloadTableView()
    func updateLoadingStatus(isLoading: Bool)
}

protocol PresenterProtocol: class {
    func initFetch()
    func getNumberOfCells() -> Int
    func getCellPhoto(at indexPath: IndexPath) -> Photo
    func userPressed(at indexPath: IndexPath) -> Bool
}


class Presenter: NSObject, PresenterProtocol {
    
    weak var delegate: MVPProtocol?
    private let apiService: APIServiceProtocol
    
    private var isLoading: Bool = false {
        didSet {
            delegate?.updateLoadingStatus(isLoading: isLoading)
        }
    }
    
    private var photos: [Photo] = [Photo]()
    
    init(delegate: MVPProtocol, apiService: APIServiceProtocol = APIService()) {
        self.delegate = delegate
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            self?.isLoading = false
            if let error = error {
                self?.delegate?.apiOnError(message: error.rawValue)
            } else {
                self?.photos = photos
                self?.delegate?.reloadTableView()
            }
        }
    }
    
    func getCellPhoto(at indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func getNumberOfCells() -> Int {
        return photos.count
    }
    
    func userPressed(at indexPath: IndexPath) -> Bool {
        if self.photos[indexPath.row].for_sale {
            return true
        }
        else {
            self.delegate?.apiOnError(message: "This item is not for sale")
            return false
        }
    }
}
