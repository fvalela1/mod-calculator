//
//  This class does all calculation logic for the mod-calculator
//
//  Calculator.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-19.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//


import Foundation

class CalculatorService {

    var formula = Stack<Calculator>()
    
    func pushOperand(operand: Double) {
        formula.push(Calculator(operand: operand))
    }
    
    // Push an operator and pop the last formula element if it is an operator
    // (can't have two operators one after the other)
    func pushOperator(arithmeticOperator: Character) {
        if formula.peek?.isOperand == false {
            _ = formula.pop()
        }
        
        formula.push(Calculator(arithmeticOperator: arithmeticOperator))
    }
    
    func clear() {
        formula.clear()
    }
    
    func recalculate() -> Double {
        if formula.isEmpty {
            return 0.0
        }
        else if formula.peek?.isOperand == false {
            _ = formula.pop()
        }
        
        var total = 0.0
        var mostRecentOperator: Character? = nil
        var tempFormulaStack = Stack<Calculator>()
        formula.reverseStack()
        while formula.isEmpty == false {
            let currentItem: Calculator = formula.pop()
            tempFormulaStack.push(currentItem)
            if currentItem.isOperand == false {
                mostRecentOperator = currentItem.arithmeticOperator
            } else if mostRecentOperator == nil {
                total += currentItem.operand
            } else {
                switch mostRecentOperator {
                case "%": total = mod(num1: total , num2: currentItem.operand)
                case .none:
                    break
                case .some(_):
                    break
                }
            }
        }
        formula = tempFormulaStack
        return total
    }
    
    func undo() {
        if formula.isEmpty == false && formula.peek?.isOperand ?? false {
            protectedFormulaPop()
        }
        protectedFormulaPop()
    }
    
    private func protectedFormulaPop() {
        if formula.isEmpty == false {
            let _ = formula.pop()
        }
    }
    
    func mod(num1: Double, num2: Double) -> Double {
        if (num2 == 0.0) {
            return Double.nan
        }
        return num1.truncatingRemainder(dividingBy: num2)
        //return Double(Int(num1) % Int(num2))
    }
}
