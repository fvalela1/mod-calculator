//
//  NumberCruncherPresenter.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-24.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

//put functions that the presenter will call to access ViewController
protocol CalculatorDelegate: class {
    func calculationDidSucceed()
    func calculationDidFailed(message: String)
}

class CalculatorPresenter {
    weak var delegate: CalculatorDelegate?
    var service = CalculatorService()
    var currentOperand: String = "0"
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }
    
    func clear() -> String {
        currentOperand = "0"
        service.clear()
        return currentOperand
    }
    
    func equals() {
        
    }
    
    func undo() {
        
    }
    
    //TODO: Complete mod function
    func mod(num1: Double, num2: Double) -> String {
        
        currentOperand = "\(service.mod(num1: num1, num2: num2))"
        return currentOperand
    }
    
    func pushOperator(op: String) -> String {
        service.pushOperand(operand: Double(op) ?? 0.0)
        return getDigitValueFromStack(Int(op) ?? 0)
    }
    
    private func getDigitValueFromStack(_ value: Int) -> String {
        let operand = "\(value)"
        if currentOperand == "0" {
            currentOperand = operand
        } else {
            currentOperand += operand
        }
        return currentOperand
        
    }
    
    private func refreshFormulaView() {
        
    }
    
    private func refreshResultView(value: Double) {
        
    }
    
    func genericDigitListener(digit: Double) {
        
    }
}
