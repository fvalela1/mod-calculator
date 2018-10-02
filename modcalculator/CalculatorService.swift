//
//  This class does all calculation logic for the mod-calculator
//
//  Calculator.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-19.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//


/*
 - does mod on two numbers
 - checks that if the user clicks an operand after writing two numbers,
 it calculates the mod of the result of the prior numbers and the new number
 - makes sure you don't have two operands after one another
 
*/

import Foundation

class CalculatorService {
    
    deinit {
        print("I'm well gone, bruh")
    }
    
    var formula = Stack<Calculator>()
    
    func pushOperand(operand: Double) {
        formula.push(Calculator(operand: operand))
    }
    
    // Push an operator and pop the last formula element if it is an operator
    // (can't have two operators one after the other)
    func pushOperator(arithmeticOperator: Character) {
        print(arithmeticOperator)
        if (!(formula.peek?.isOperand ?? false)) {
            _ = formula.pop()
        }
        formula.push(Calculator(arithmeticOperator: arithmeticOperator))
    }
    
    func clear() {
        formula.clear()
    }
    
    func recalculate() -> Double {
        if (formula.isEmpty) {
            return 0.0
        }
        else if (!(formula.peek?.isOperand)!) {
            _ = formula.pop()
        }
        
        var total = 0.0
        var mostRecentOperator: Character? = nil
        var count = 0
        while (count < formula.size) {
            guard let currentItem = formula.peek else { return 0.0 }
            if (!currentItem.isOperand) {
                mostRecentOperator = currentItem.arithmeticOperator
            } else if (mostRecentOperator == nil) {
                total += currentItem.operand
            } else {
                switch mostRecentOperator {
                case "%": total = mod(num1: total, num2: currentItem.operand)
                case .none:
                    break
                case .some(_):
                    break
                }
            }
            count += 1
        }
        return total
    }
    
    func undo() {
        if (!formula.isEmpty && (formula.peek?.isOperand)!) {
            protectedFormulaPop()
        }
        protectedFormulaPop()
    }
    
    private func protectedFormulaPop() {
        if(!formula.isEmpty) {
            let _ = formula.pop()
        }
    }
    
    func mod(num1: Double, num2: Double) -> Double {
        if (num2 == 0.0) {
            return Double.nan
        }
        return Double(Int(num1) % Int(num2))
    }
}
