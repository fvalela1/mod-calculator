//
//  ItemModel.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-19.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

class ItemModel {
    
    var operand = 0
    var arithmeticOperator = " "
    lazy var isOperand: Bool = {
        return arithmeticOperator == " "
    }()
    
    init(arithmeticOperator: String) {
        self.arithmeticOperator = arithmeticOperator
    }
    
    init(operand: Int) {
        self.operand = operand
    }
    
}
