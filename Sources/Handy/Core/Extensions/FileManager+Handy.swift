//
//  FileManager.swift
//  Handy
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit

public extension FileManager {
    class var documentPath: String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
    }
    class var cachesPath: String {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
    }
    class var tempPath: String {
        NSTemporaryDirectory()
    }
}
