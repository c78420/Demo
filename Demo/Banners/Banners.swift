//
//  Banners.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/16.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

let DURATION = 2.0
let REPEAT_COUNT = 0
let SPEED = 0.5

class Banners: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let images = ["Banners_Image1", "Banners_Image2", "Banners_Image3", "Banners_Image4", "Banners_Image1"]
    var collectionViewImageIndex = 0
    var scrollViewImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCollectionView()
        self.setupImageView()
        self.setupScrollView()
        
        Timer.scheduledTimer(timeInterval: DURATION, target: self, selector: #selector(self.collectionViewMoveToNext), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: DURATION, target: self, selector: #selector(self.scrollViewViewMoveToNext), userInfo: nil, repeats: true)
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
    }
    
    func setupImageView() {
        var imageArray = [UIImage]()
        
        for imageName in self.images {
            if let image = UIImage(named: imageName) {
                imageArray.append(image)
            }
        }
        
        self.imageView.animationImages = imageArray
        self.imageView.animationDuration = DURATION * Double(self.images.count)
        self.imageView.animationRepeatCount = REPEAT_COUNT
        self.imageView.startAnimating()
    }
    
    func setupScrollView() {
        var imageArray = [UIImageView]()
        
        for (index, imageName) in self.images.enumerated() {
            if let image = UIImage(named: imageName) {
                let imageView = UIImageView(frame: CGRect(x: self.scrollView.frame.size.width * CGFloat(index), y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageArray.append(imageView)
                
                self.scrollView.addSubview(imageView)
            }
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(self.images.count), height: self.scrollView.frame.size.height)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
    }
    
    @objc func collectionViewMoveToNext() {
        self.collectionViewImageIndex += 1
        if self.collectionViewImageIndex >= self.images.count {
            self.collectionViewImageIndex = 0
            self.collectionView.selectItem(at: IndexPath(item: self.collectionViewImageIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            self.collectionViewMoveToNext()
        }
        else {
            self.collectionView.selectItem(at: IndexPath(item: self.collectionViewImageIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    @objc func scrollViewViewMoveToNext() {
        self.scrollViewImageIndex += 1
        if self.scrollViewImageIndex >= self.images.count {
            self.scrollViewImageIndex = 0
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(self.scrollViewImageIndex), y: 0)
            self.scrollViewViewMoveToNext()
        }
        else {
            UIView.animate(withDuration: SPEED) {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(self.scrollViewImageIndex), y: 0)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Banners: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension Banners: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerCell {
            cell.imageView.image = UIImage(named: self.images[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension Banners: UICollectionViewDelegate {
    
}

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
