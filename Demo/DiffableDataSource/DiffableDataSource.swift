//
//  DiffableDataSource.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/6.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

final class SampleCollectionReusableView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textColor = .white

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fill(with title: String) {
        titleLabel.text = title
    }
}

class DiffableDataSource: UIViewController {
    
    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, UIColor> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, UIColor>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sampleIdentifier", for: indexPath)
            cell.backgroundColor = item

            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sampleHeaderIdentifier", for: indexPath) as? SampleCollectionReusableView else {
                    fatalError("Header is not registered")
                }

                headerView.fill(with: "My Awesome Colours")
                return headerView
            default:
                fatalError("Element \(kind) not supported")
            }
        }

        return dataSource
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.headerReferenceSize = CGSize(width: 0, height: 60)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "sampleIdentifier")
        collectionView.register(SampleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "sampleHeaderIdentifier")

        return collectionView
    }()

    private let colors: [UIColor] = [
        .brown,
        .purple,
        .systemBlue,
        .systemRed,
        .systemGray,
        .systemPink
    ]
    
    private func update(with items: [UIColor]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UIColor>()
        snapshot.appendSections([0])

        snapshot.appendItems(items, toSection: 0)

        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func loadView() {
        view = collectionView
        view.backgroundColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = diffableDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        update(with: colors)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.update(with: self.colors.shuffled())

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.update(with: self.colors.shuffled())

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.update(with: self.colors.shuffled())

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.update(with: self.colors.shuffled())
                    }
                }
            }
        }
    }

}
