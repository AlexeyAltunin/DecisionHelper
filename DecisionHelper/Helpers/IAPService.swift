//
//  IAPService.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 12/02/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

enum IAPPRoduct: String {
    case nonConsumable = "com.alexey.altunin.DecisionHelper.FullVersion"
}

import Foundation
import StoreKit

class IAPServise: NSObject {
    private override init() {}
    static let shared = IAPServise()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set = [
            IAPPRoduct.nonConsumable.rawValue
        ]
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPPRoduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("restoring purchases")
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPServise: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPServise: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}
