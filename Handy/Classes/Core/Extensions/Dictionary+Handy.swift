//
//  Dictionary+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit

extension Dictionary: HandyCompatibleValue{}
extension Dictionary: HandyClassCompatibleValue{}


public extension HandyExtension where Base == [AnyHashable: Any]{
    func allKeys() -> [AnyHashable]{
        var temp:[AnyHashable] = []
        for (key,_) in base {
            temp.append(key)
        }
        return temp
    }
}
