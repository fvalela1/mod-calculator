//
//  ItemModel.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-19.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

class ItemModel {
    
    var operand: Double = 0.0
    var arithmeticOperator: Character = " "
    lazy var isOperand: Bool = {
        return arithmeticOperator == " "
    }()
    
    init(arithmeticOperator: Character) {
        self.arithmeticOperator = arithmeticOperator
    }
    
    init(operand: Double) {
        self.operand = operand
    }
    
}
