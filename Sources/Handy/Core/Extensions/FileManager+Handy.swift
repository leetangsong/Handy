//
//  FileManager.swift
//  Handy
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit

public extension HandyClassExtension where Base: FileManager{
    
    static var documentPath: String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
    }
    static var cachesPath: String {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
    }
    static var tempPath: String {
        NSTemporaryDirectory()
    }
    
    @discardableResult
    static func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        if srcURL.path == dstURL.path {
            return true
        }
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func removeFile(fileURL: URL) -> Bool {
        removeFile(filePath: fileURL.path)
    }
    
    @discardableResult
    static func removeFile(filePath: String) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
            }
            return true
        } catch {
            return false
        }
    }
    
    static func folderExists(atPath path: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    
    /// 获取文件大小
    /// - Parameter path: 文件路径
    /// - Returns: 文件大小
    static func fileSize(atPath path: String) -> Int {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            let fileSize = try? fileManager.attributesOfItem(atPath: path)[.size]
            if let size = fileSize as? Int {
                return size
            }
        }
        return 0
    }
    
    /// 获取文件夹里的所有文件大小
    /// - Parameter path: 文件夹路径
    /// - Returns: 文件夹大小
    static func folderSize(atPath path: String) -> Int {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) { return 0 }
        let childFiles = fileManager.subpaths(atPath: path)
        var folderSize = 0
        childFiles?.forEach({ (fileName) in
            let fileAbsolutePath = path + "/" + fileName
            folderSize += fileSize(atPath: fileAbsolutePath)
        })
        return folderSize
    }
}
