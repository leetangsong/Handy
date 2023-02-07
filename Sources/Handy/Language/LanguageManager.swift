//
//  LanguageManager.swift
//  Handy
//
//  Created by leetangsong on 2023/1/16.
//

import Foundation


public protocol LanguageCompatible: AnyObject { }
public class LanguageExtension<Base>: NSObject {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
extension LanguageCompatible {
    public var lang: LanguageExtension<Self> {
        get{ return LanguageExtension(self) }
        set{ }
    }
}

public class LanguageManager{
    var bundle: Bundle?
    
    
}
