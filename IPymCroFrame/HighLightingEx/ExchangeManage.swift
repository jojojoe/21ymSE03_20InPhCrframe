//
//  DataEncoding.swift
//  IPymCroFrame
//
//  Created by JOJO on 2021/10/22.
//  Copyright © 2021 CroFrame. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class ExchangeManage: NSObject {
    class func exchangeWithSSK(objcetID: String, completion: @escaping (PurchaseResult) -> Void) {        
        SwiftyStoreKit.purchaseProduct(objcetID) { a in
            completion(a)
        }
    }
}
