//
//  ItemModel.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-19.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

class Calculator {
    
    var operand: Double = 0.0
    var arithmeticOperator: Character = " "
    var isOperand: Bool
    
    
    init(arithmeticOperator: Character) {
        self.isOperand = arithmeticOperator == " "
        self.arithmeticOperator = arithmeticOperator
    }
    
    init(operand: Double) {
        self.isOperand = arithmeticOperator == " "
        self.operand = operand
    }
    
}
