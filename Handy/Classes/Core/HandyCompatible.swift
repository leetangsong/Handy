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




///带有泛型对象
public class HandyTypealiasExtension<Base, T> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

///带有泛型值类型用   比如数组
public class HandyTypealiasValueExtension<Base, T> {
    public var base: UnsafeMutablePointer<Base>
    public init(_ base: UnsafeMutablePointer<Base>) {
        self.base = base
    }
}

public protocol HandyTypealiasCompatible: AnyObject {
    associatedtype ItemType
}

public protocol HandyTypealiasCompatibleValue {
    associatedtype ItemType
}

extension HandyTypealiasCompatible {
    public var handy: HandyTypealiasExtension<Self, ItemType> {
        get{ return HandyTypealiasExtension(self) }
        set{ }
    }
}

extension HandyTypealiasCompatibleValue {
    public var handy: HandyTypealiasValueExtension<Self, ItemType> {
        mutating get{
            withUnsafeMutablePointer(to: &self) { pointer in
                return HandyTypealiasValueExtension(pointer)
            }
        }
        set{ }
    }
}



public class HandyClassTypealiasExtension<Base, T> {
    public static var base: Base.Type{
        return Base.self
    }
}
public protocol HandyClassTypealiasCompatible: AnyObject {
    associatedtype ItemType
}
public protocol HandyClassTypealiasCompatibleValue {
    associatedtype ItemType
}

extension HandyClassTypealiasCompatible {
    public static var handy: HandyClassTypealiasExtension<Self, ItemType>.Type{
        get{ return  HandyClassTypealiasExtension<Self, ItemType>.self }
        set{ }
    }
}
extension HandyClassTypealiasCompatibleValue {
    public static var handy: HandyClassTypealiasExtension<Self, ItemType>.Type{
        get{ return  HandyClassTypealiasExtension<Self, ItemType>.self }
        set{ }
    }
}
