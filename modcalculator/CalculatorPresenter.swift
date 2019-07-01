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
    func buttonDidTap(_ value: Int)
    func resultsDidRefresh(value: Double)
    func formulaDidRefresh(value: Double)
    func formulaDidRefresh(value: (Double, Character, Double))
    func formulaDidRefresh(value: (Double, Character))
    func calculationDidSucceed()
    func calculationDidFailed(message: String)
}

class CalculatorPresenter {

    weak var delegate: CalculatorDelegate?
    private var digitStack: Stack<String>
    private var calc: CalculatorService
    private var lastOperator: Character?
    private var lastOperand: Double?
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
        self.digitStack = Stack<String>()
        self.calc = CalculatorService()
        self.lastOperand = nil
        self.lastOperator = nil
    }

    // Clear the calculator stack and the local digit stack.
    func clear() {
        calc.clear()
        digitStack.clear()
        lastOperand = nil
        lastOperator = nil
        refreshFormulaView()
        refreshResultView(value: calc.recalculate())
      
    }
    
    // Push the digit stack to the calculator, recalculate the result and display it.
    func equals() {
        if digitStack.isEmpty == false {
            calc.pushOperand(operand: getDigitValueFromStack())
            digitStack.clear()
            lastOperand = calc.recalculate()
            refreshResultView(value: lastOperand ?? 0.0)
            lastOperator = nil
        }
    }
    
    func pushOperator(op: Character) {
        if digitStack.isEmpty == false {
            let completeDigitValue = getDigitValueFromStack()
            calc.pushOperand(operand: completeDigitValue)
            let nilOperandFlag = lastOperand == nil ? true : false
            lastOperand = calc.recalculate()
            lastOperator = op
            calc.pushOperator(arithmeticOperator: op)
            digitStack.clear()
            if nilOperandFlag {
                refreshResultView(value: 0.0)
            } else {
                refreshResultView(value: lastOperand ?? 0.0)
            }
        } else if lastOperand != nil {
            calc.pushOperator(arithmeticOperator: op)
        } else if lastOperand == nil {
            return
        }
        lastOperator = op
        refreshFormulaView()
    }
    
    private func getDigitValueFromStack() -> Double {
        let valueToReturn = digitStack.getItems().compactMap { $0 }.joined()
        return getValidDouble(value: valueToReturn)
    }
    
    // Undo the last operation and refresh the views to reflect the change.
    func undo() {
        if digitStack.isEmpty {
            calc.undo()
            lastOperator = nil
            lastOperand = calc.recalculate()
            refreshFormulaView()
            refreshResultView(value: lastOperand ?? 0.0)
        } else {
            digitStack.clear()
            refreshFormulaView()
        }
    }
    
    private func getValidDouble(value: String) -> Double {
        if value.isDouble() == false {
            return Double.nan
        }
        let valueToDouble = Double(value)!
        let valueWithDecimalPrecision = (value.firstIndex(of: ".")) == nil ? value + ".0" : value
        return String(valueToDouble) == valueWithDecimalPrecision ? valueToDouble : Double.nan
        
    }
    
    private func refreshFormulaView() {
        
        let completeDigitalValue = getDigitValueFromStack()
        let current: Double = digitStack.isEmpty ? 0.0 : completeDigitalValue
        switch lastOperator != nil && lastOperand != nil {
        case true:
            let previous = lastOperand ?? -1
            if(digitStack.isEmpty) {
                delegate?.formulaDidRefresh(value: (previous, lastOperator!))
            } else {
                delegate?.formulaDidRefresh(value: (previous, lastOperator!, current))
            }
            break
        case false:
            if lastOperand != nil && lastOperand!.isNaN == false {
                let cleanLastInt: Double = lastOperand ?? -1
                delegate?.formulaDidRefresh(value: cleanLastInt)
            } else {
                delegate?.formulaDidRefresh(value: current)
            }
            break
        }
    }
    
    //TODO
    private func refreshResultView(value: Double) {
        delegate?.resultsDidRefresh(value: value)
    }
    
    private func refreshFormulaView(value: Double) {
        delegate?.formulaDidRefresh(value: value)
    }
    
    func genericDigitListener(digit: String) {
        if lastOperator == nil {
            calc.clear()
            lastOperand = nil
        }
        digitStack.push(digit)
        refreshFormulaView()
    }
    
}
extension String {
    
    func isDouble() -> Bool {
        if let doubleValue = Double(self) {
            if doubleValue >= 0 {
                return true
            }
        }
        return false
    }
}
