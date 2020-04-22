//
//  MessierDetail.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/22.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class MessierDetail: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var messierViewModel: MessierViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.alpha = 0.0
        
        // #1 - Define a closure (completion block) INSTANCE for updating a UIImageView
        // once an image downloads.
        let imageCompletionClosure = { ( imageData: NSData ) -> Void in
            
            // #2 - Download occurs on background thread, but UI update
            // MUST occur on the main thread.
            DispatchQueue.main.async {
                
                // #3 - Animate the appearance of the Messier image.
                UIView.animate(withDuration: 1.0, animations: {
                    self.imageView.alpha = 1.0
                    self.imageView?.image = UIImage(data: imageData as Data)
                    self.view.setNeedsDisplay()
                })
                
            } // end DispatchQueue.main.async
            
        } // end let imageCompletionClosure...
        
        // #6 - Update the UI with info from the Messier object
        // the user chose to inspect.
        titleLabel.text = messierViewModel?.formalName
        subtitleLabel.text = messierViewModel?.commonName
        updatedLabel.text = messierViewModel?.dateUpdated
        descriptionTextView.attributedText = messierViewModel?.textDescription
        
        // #7 - Start image downloading in background.
        messierViewModel?.download(completionHanlder: imageCompletionClosure)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        // #8 - make sure UITextView shows beginning
        // of Messier object description
        self.descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
        
    }

}
