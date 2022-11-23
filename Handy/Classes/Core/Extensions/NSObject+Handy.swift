//
//  NSObject+Handy.swift
//  Handy
//
//  Created by leetangsong on 2022/9/29.
//


import UIKit

public extension NSObject {
  func safeRemoveObserver(_ observer: NSObject, forKeyPath keyPath: String) {
    switch self.observationInfo {
    case .some:
      self.removeObserver(observer, forKeyPath: keyPath)
    default:
      debugPrint("observer does no not exist")
    }
  }
}
