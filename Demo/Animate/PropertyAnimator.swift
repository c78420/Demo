//
//  PropertyAnimator.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/10/3.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class PropertyAnimator: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let items: [City] = City.buildCities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: CityCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = CityCollectionViewFlowLayout(itemSize: CityCollectionViewCell.cellSize);
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

}

extension PropertyAnimator: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        cell.configure(with: items[indexPath.item], collectionView: collectionView, index: indexPath.row)
        return cell
    }
}

extension PropertyAnimator: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)! as! CityCollectionViewCell
        selectedCell.toggle()
    }
}
