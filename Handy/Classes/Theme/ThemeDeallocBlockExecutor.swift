//
//  ThemeDeallocBlockExecutor.swift
//  Handy
//
//  Created by leetangsong on 2022/10/19.
//

import UIKit


typealias DeallocBlock = ()->Void
class ThemeDeallocBlockExecutor: NSObject {
    var deallocBlock: DeallocBlock?
    init(deallocBlock: DeallocBlock? = nil) {
        self.deallocBlock = deallocBlock
    }
    
    deinit {
        deallocBlock?()
        deallocBlock = nil
    }
}
