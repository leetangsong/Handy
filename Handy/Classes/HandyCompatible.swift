//
//  HandyCompatible.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit
public protocol HandyCompatible: AnyObject { }
public class HandyExtension<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
extension HandyCompatible {
    public var handy: HandyExtension<Self> {
        get{ return HandyExtension(self) }
        set{ }
    }
}


public protocol HandyCompatibleValue {}

extension HandyCompatibleValue {
    public var handy: HandyExtension<Self> {
        get{ return HandyExtension(self) }
        set{ }
    }
}

public class HandyClassExtension<Base> {
    public static var base: Base.Type{
        return Base.self
    }
}
public protocol HandyClassCompatible: AnyObject { }
public protocol HandyClassCompatibleValue {}

extension HandyClassCompatible {
    public static var handy: HandyClassExtension<Self>.Type{
        get{ return  HandyClassExtension<Self>.self }
        set{ }
    }
}
extension HandyClassCompatibleValue {
    public static var handy: HandyClassExtension<Self>.Type{
        get{ return  HandyClassExtension<Self>.self }
        set{ }
    }
}





public class HandyGenericityExtension<Base, T> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}


public class HandyGenericityValueExtension<Base, T> {
    public var base: UnsafeMutablePointer<Base>
    public init(_ base: UnsafeMutablePointer<Base>) {
        self.base = base
    }
}

public protocol HandyGenericityCompatible: AnyObject {
    associatedtype ItemType
}

public protocol HandyGenericityCompatibleValue {
    associatedtype ItemType
}

extension HandyGenericityCompatible {
    public var handy: HandyGenericityExtension<Self, ItemType> {
        get{ return HandyGenericityExtension(self) }
        set{ }
    }
}

extension HandyGenericityCompatibleValue {
    public var handy: HandyGenericityValueExtension<Self, ItemType> {
        mutating get{
            withUnsafeMutablePointer(to: &self) { pointer in
                return HandyGenericityValueExtension(pointer)
            }
        }
        set{ }
    }
}



public class HandyClassGenericityExtension<Base, T> {
    public static var base: Base.Type{
        return Base.self
    }
}
public protocol HandyClassGenericityCompatible: AnyObject {
    associatedtype ItemType
}
public protocol HandyClassGenericityCompatibleValue {
    associatedtype ItemType
}

extension HandyClassGenericityCompatible {
    public static var handy: HandyClassGenericityExtension<Self, ItemType>.Type{
        get{ return  HandyClassGenericityExtension<Self, ItemType>.self }
        set{ }
    }
}
extension HandyClassGenericityCompatibleValue {
    public static var handy: HandyClassGenericityExtension<Self, ItemType>.Type{
        get{ return  HandyClassGenericityExtension<Self, ItemType>.self }
        set{ }
    }
}
