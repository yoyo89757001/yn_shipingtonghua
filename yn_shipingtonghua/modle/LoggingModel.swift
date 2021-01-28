//
//  LoggingModel.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/28.
//

import HandyJSON

class LoggingModel: HandyJSON {
    required init() {}
    var success = false
    var errorMsg = ""
    var code = ""
    var result = ""
    
    
    class ResultObj: HandyJSON {
        required init() {}
        
    }
}
