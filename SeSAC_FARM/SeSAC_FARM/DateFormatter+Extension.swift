//
//  DateFormat+Extension.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/12.
//

import Foundation

extension DateFormatter {

    //timeStamp에 쓰일 모든 종류의 date formatter 생성
    
    //Fri - 금
    static var postDateFormat: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "MM/dd hh:mm"
        date.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        return date
    }
}
