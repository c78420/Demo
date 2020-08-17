//
//  IAP.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/6/27.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class IAP: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        IAPManager.shared.getProducts()
        
        IAPManager.shared.getProduct = {[weak self] in
            print("getProduct")
        }
        
        IAPManager.shared.purchased = {[weak self] in
            guard let receiptURL = Bundle.main.appStoreReceiptURL,  let data = try? Data(contentsOf: receiptURL)  else {
                return
            }
            print(data)
            let receiptString = data.base64EncodedString(options: [])
            print(receiptString)
            print("purchased")
        }
    }

    @IBAction func byAction(_ sender: Any) {
        IAPManager.shared.buy(product: IAPManager.shared.products.first!)
    }
}
