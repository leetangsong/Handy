//
//  Array+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit


extension Array: HandyGenericityCompatibleValue{
    public typealias ItemType = Element
}
extension Array: HandyClassGenericityCompatibleValue{}

extension HandyGenericityExtension where Base == Array<T>{
    public subscript(index:Int) -> T?{
        if index<base.count {
            return base[index]
        }
        return nil
    }
}

extension HandyGenericityValueExtension where Base == Array<T>, T: Equatable{
    public func remove(_ object: T, isAll: Bool = false){
        if let index = base.pointee.firstIndex(of: object){
            base.pointee.remove(at: index)
            if isAll {
                remove(object, isAll: isAll)
            }
        }
    }
}

extension CGFloat: HandyClassCompatibleValue{}


extension HandyClassExtension where Base == CGFloat{
    public static func middleValue(from: CGFloat, to: CGFloat, percent: CGFloat) -> CGFloat{
        return from + (to - from)*percent
    }
}

