//
//  IAPManager.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/6/28.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import StoreKit

class IAPManager: NSObject {
    let productID1 =        "com.my.demo.project.test_1"
    let productID2 =        "com.my.demo.project.test_2"
    let productID10 =       "com.my.demo.project.test_10"
    let productID500 =      "com.my.demo.project.test_500"
    let productID1000 =     "com.my.demo.project.test_501"
    let productID500_1 =    "com.my.demo.project.test_500.1"
    let productIDi500 =     "com.my.demo.project.igold01.500"
    let productIDi1000 =    "com.my.demo.project.igold02.1000"
    let productIDi2000 =    "com.my.demo.project.igold03.2000"
    
    var getProduct: (()->Void)? = nil
    var purchased: (()->Void)? = nil
    
    static let shared = IAPManager()
    var products = [SKProduct]()
    fileprivate var productRequest: SKProductsRequest!
    
    func getProductIDs() -> [String] {
        [productID1, productID2, productID10, productID500, productID1000, productID500_1, productIDi500, productIDi1000, productIDi2000]
    }
    
    func getProducts() {
        let productIds = getProductIDs()
        let productIdsSet = Set(productIds)
        print("\(productIdsSet)")
        productRequest = SKProductsRequest(productIdentifiers: productIdsSet)
        productRequest.delegate = self
        productRequest.start()
        
        SKPaymentQueue.default().add(IAPManager.shared)
    }
    
    func buy(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            // show error
        }
    }
}
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.products.forEach {
            print($0.localizedTitle, $0.price, $0.regularPrice, $0.localizedDescription)
        }
        getProduct?()
        self.products = response.products
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            print($0.payment.productIdentifier, $0.transactionState.rawValue)
            switch $0.transactionState {
            case .purchased:
                purchased?()
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("failed")
                print($0.error ?? "")
                if ($0.error as? SKError)?.code != .paymentCancelled {
                    // show error
                }
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("restored")
                SKPaymentQueue.default().finishTransaction($0)
            case .purchasing, .deferred:
                print("purchasing, deferred")
                break
            @unknown default:
                break
            }
        }
    }
}

extension SKProduct {
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
