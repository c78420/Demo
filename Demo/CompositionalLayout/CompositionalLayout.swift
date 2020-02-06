//
//  CompositionalLayout.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/2.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class CompositionalLayout: UIViewController {
    
    var collectionView: UICollectionView?
    
    // 初始化 compositional layout
    lazy var CollectionViewLayout: UICollectionViewLayout = {
        // 4
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     
        // 3
        // fractionalWidth 與 fractionalHeight：寬度或高度是容器的某個比例，比方 1（一樣）或 0.5（一半）
        // absolute：指定一個絕對值
        // estimated：設定這個 item 或 item 為 self-sizing，並且給定一個預測值，就像我們原本在設定 self-sizing 時一樣
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(8)
     
        // 2
        let section = NSCollectionLayoutSection(group: group)
        // none：顧名思義，就是不會有垂直向的滾動（預設值）
        // continuous：連續的滾動
        // continuousGroupLeadingBoundary：連續的滾動，但會最後停在 group 的前緣
        // paging：每次會滾動跟 CollectionView 一樣寬（或一樣高）的距離
        // groupPaging：每次會滾動一個 group
        // groupPagingCentered：每次會滾動一個 group，並且停在 group 置中的地方
        section.orthogonalScrollingBehavior = .continuous
        // 增加 section 邊緣的空間
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
     
        // 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    lazy var CollectionViewLayout2: UICollectionViewLayout = {
        // 1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // 3
        // fixed：指定固定的距離
        // flexible：指定一個可伸長的最小距離
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(8), bottom: nil)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    // Item 垂直相疊的橫向滾動（AppStore）
    lazy var CollectionViewLayout3: UICollectionViewLayout = {
        // 提供三種不同形狀的 item
        let layoutSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let layoutSize2 = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(65))
        let item2 = NSCollectionLayoutItem(layoutSize: layoutSize2)
        let layoutSize3 = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(85))
        let item3 = NSCollectionLayoutItem(layoutSize: layoutSize3)
         
        // 給剛好大小的 group
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(205))
         
        // 用 .vertical 指明我們的 group 是垂直排列的
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [item, item2, item3])
         
        // 這裡指的是垂直的間距了
        group.interItemSpacing = .fixed(5)
         
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
         
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    // Nested group（巢狀）
    lazy var CollectionViewLayout4: UICollectionViewLayout = {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
         
        let layoutSize2 = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .absolute(45))
        let item2 = NSCollectionLayoutItem(layoutSize: layoutSize2)
        let layoutSize3 = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .absolute(65))
        let item3 = NSCollectionLayoutItem(layoutSize: layoutSize3)
         
        // 右邊的子 group
        let subGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .absolute(120))
        let subGroup = NSCollectionLayoutGroup.vertical(layoutSize: subGroupSize, subitems: [item2, item3])
        subGroup.interItemSpacing = .fixed(10)
         
        // 包含一個左邊的 item 跟右邊的子 group 的大 group
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(135), heightDimension: .absolute(120))
         
        // 同時在 group 裡面放 group 跟 item 兩種 layout 物件
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item, subGroup])
         
        group.interItemSpacing = .fixed(5)
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
         
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    // Header 的實作 —— Boundary Supplementary Item
    // DataSource 實作 viewForSupplementaryElementOfKind
    // CollectionView register header
    lazy var CollectionViewLayout5: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // 設定 header 的大小
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))

        // 負責描述 supplementary item 的物件
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top, absoluteOffset: CGPoint(x: 0, y: -5))

        let section = NSCollectionLayoutSection(group: group)

        // 指定 supplementary item 給 section
        section.boundarySupplementaryItems = [headerItem]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    // 小紅點 badge —— Supplementary Item
    // DataSource 實作 viewForSupplementaryElementOfKind
    lazy var CollectionViewLayout6: UICollectionViewLayout = {
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        // itemAnchor 代表的是 item 用來對齊的錨點
        // containerAnchor 代表的是包含這個 item 的 section 或 group 用來對齊的錨點
        let badgeContainerAnchor = NSCollectionLayoutAnchor(edges: [.top, .leading], absoluteOffset: CGPoint(x: 10, y: 10))
        let badgeItemAnchor = NSCollectionLayoutAnchor(edges: [.bottom, .trailing], absoluteOffset: CGPoint(x: 0, y: 0))
        let badgeItem = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: "BadgeView", containerAnchor: badgeContainerAnchor, itemAnchor: badgeItemAnchor)
         
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badgeItem])

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(8), bottom: nil)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    // 提供 section 背景的 decoration item
    class SectionBackgroundDecorationView: UICollectionReusableView {
        
    }
    lazy var CollectionViewLayout7: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(8), bottom: nil)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        // 設定 decoration view
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: "SectionBackgroundDecorationView")
        decorationItem.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 10, bottom: 10, trailing: 10)
        section.decorationItems = [decorationItem]
        
        // 註冊 decoration view
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "SectionBackgroundDecorationView")
        
        return layout
    }()
    
    // Section Provider
    // CollectionView 裡面，有多種不一樣的 section 設計
//    lazy var CollectionViewLayout8: UICollectionViewLayout = {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
//            switch sectionIndex {
//            case 0:
//                return featureSectionlayout
//            case 1:
//                return pileSectionLayout
//            default:
//                return normalSectionLayout
//            }
//        }
//        return layout
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 指定 layout 的方法為 UICollectionViewCompositionalLayout
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionViewLayout)
        self.collectionView?.dataSource = self
        
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(self.collectionView!)
    }

}

extension CompositionalLayout: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .yellow
        
        return cell
    }
}


