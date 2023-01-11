//
//  HandyNaivgationWeakHost.swift
//  Handy
//
//  Created by leetangsong on 2023/1/10.
//

import UIKit

class HandyNavigationWeakHost: HandyWeakHost {
    weak var navigationController: UINavigationController?
    
    deinit{
        navigationController = nil
    }
}
