//
//  DragAndDrop.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/12/3.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class DragAndDrop: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
        firstImageView.isUserInteractionEnabled = true
        secondImageView.isUserInteractionEnabled = true
    }
}

extension DragAndDrop: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // 有時候當我們將 Image 拖到 Board 時，可能會拖動多於一個 Image。這樣會回傳一個 session.items 陣列，所以我們為每個 dragItem 運行以下程式碼
        for dragItem in session.items {
            // 我們將 UIImage 物件加載到 dragItems 中
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { object, error in
                // 如果發生錯誤，我們使用 guard 語法來處理。如果錯誤存在 (例如該項目不符合 UIImage 類別)，那麼我們會展示一條錯誤訊息
                guard error == nil else { return print("Failed to load our dragged item") }
                guard let draggedImage = object as? UIImage else { return }
                // 如果沒有錯誤，我們將 imageView 的 Image 設置為 draggedImage
                DispatchQueue.main.async {
                    let centerPoint = session.location(in: self.view)
                    // 確認手指放置的位置，以查看是否將 Image 設置為第一個 imageView 或第二個 imageView。請注意，我們手指的位置正正在 Image 的中心
                    if session.location(in: self.view).y <= self.firstImageView.frame.maxY {
                        self.firstImageView.image = draggedImage
                        self.firstImageView.center = centerPoint
                    } else {
                        self.secondImageView.image = draggedImage
                        self.secondImageView.center = centerPoint
                    }
                }
            })
        }
    }
    
    // 此方法告訴 Delegate 置放 Session 已更改。在我們的範例中，如果 Session 已被更新，我們就希望複製這些項目
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
     
    // 該方法檢查視圖是否可以處理 Session 的拖動項目。在現在這個情境，我們希望 View 接受圖片為拖動項目
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
}

extension DragAndDrop: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if session.location(in: self.view).y <= self.firstImageView.frame.maxY {
            guard let image = firstImageView.image else { return [] }
            let provider = NSItemProvider(object: image)
            let item = UIDragItem(itemProvider: provider)
            return [item]
        } else {
            guard let image = secondImageView.image else { return [] }
            let provider = NSItemProvider(object: image)
            let item = UIDragItem(itemProvider: provider)
            return [item]
        }
    }
}
