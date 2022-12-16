//
//  ThemeDeallocBlockExecutor.swift
//  Handy
//
//  Created by leetangsong on 2022/11/2.
//

import Foundation

class ThemeDeallocBlockExecutor{
    var pickerHelper: ThemePickerHelper?
    init(pickerHelper: ThemePickerHelper?) {
        self.pickerHelper = pickerHelper
    }
    deinit {
        if let pciker = pickerHelper {
            ThemeManager.themePickers.handy.remove(pciker)
        }
    }
}
