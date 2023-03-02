//
//  Array+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit


extension Array: HandyTypealiasCompatibleValue{
    public typealias ItemType = Element
}

public extension HandyTypealiasValueExtension where Base == Array<T>, T: Equatable{
    
    subscript(index:Int) -> T?{
         get{
            if index<base.pointee.count {
                return base.pointee[index]
            }
            return nil
         }set{
            if index<base.pointee.count, let newValue = newValue {
                base.pointee[index] = newValue
            }
        }
    }
    
    func remove(_ object: T, isAll: Bool = false){
        if let index = base.pointee.firstIndex(of: object){
            base.pointee.remove(at: index)
            if isAll {
                remove(object, isAll: isAll)
            }
        }
        
    }
}

extension CGFloat: HandyClassCompatibleValue{}


public extension HandyClassExtension where Base == CGFloat{
    static func middleValue(from: CGFloat, to: CGFloat, percent: CGFloat) -> CGFloat{
        return from + (to - from)*percent
    }
}

