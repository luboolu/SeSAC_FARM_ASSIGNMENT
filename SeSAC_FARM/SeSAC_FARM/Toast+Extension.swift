//
//  Toast+Extension.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/06.
//

import Foundation

import Toast
import UIKit

var style = ToastStyle()

extension ToastStyle {
    
    static var defaultStyle: ToastStyle {
        
        // this is just one of many style options
        style.messageColor = .white
        style.backgroundColor = .lightGray
        style.messageFont = .systemFont(ofSize: 13)
        
        return style
    }
    
}
