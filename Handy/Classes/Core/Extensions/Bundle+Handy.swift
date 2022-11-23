//
//  Bundle+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//

import UIKit

extension Bundle: HandyCompatible{}

extension HandyExtension where Base == Bundle{}
public extension HandyClassExtension where Base == Bundle{
    static func bundle(with cls: AnyClass, name: String) -> Bundle?{
        var bundle:Bundle? = Bundle.init(for: cls)
        if let url = bundle?.url(forResource: name, withExtension: "bundle"){
            bundle = Bundle.init(url: url)
        }
        return bundle
    }
}
