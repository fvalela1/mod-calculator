//
//  NumberCruncherPresenter.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-24.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

//put functions that the presenter will call to access ViewController
protocol CalculatorDelegate {
    func calculationDidSucceed()
    func calculationDidFailed(message: String)
}

class CalculatorPresenter {
    private var delegate: CalculatorDelegate
    private var digitStack: Stack<Double>
    private var calc: CalculatorService
    private var lastOperator: Character?
    private var lastOperand: Double?
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
        self.digitStack = Stack<Double>()
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
        if(!digitStack.isEmpty) {
            calc.pushOperand(operand: getDigitValueFromStack())
            digitStack.clear()
            lastOperand = calc.recalculate()
            refreshResultView(value: lastOperand ?? 0.0)
            lastOperator = nil
            refreshFormulaView()
        }
    }
    // Undo the last operation and refresh the views to reflect the change.
    func undo() {
        if (digitStack.isEmpty) {
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
    
    func pushOperator(op: Character) {
        if (!digitStack.isEmpty) {
            let completeDigitValue = getDigitValueFromStack()
            calc.pushOperand(operand: completeDigitValue)
            lastOperand = calc.recalculate()
            lastOperator = op
            calc.pushOperator(arithmeticOperator: op)
            digitStack.clear()
            refreshResultView(value: lastOperand ?? 0.0)
        } else if (lastOperand != nil) {
            calc.pushOperator(arithmeticOperator: op)
        }
        lastOperator = op
        refreshFormulaView()
    }
    
    private func getDigitValueFromStack() -> Double {
        var ret = 0.0
        let reversedDigitStack = digitStack.reversed()
        for (index, digit) in reversedDigitStack.enumerated() {
            ret += digit! * pow(10.0, Double(index))
        }
        
        
        return ret
    }
    
    private func refreshFormulaView() {
//        let completeDigitalValue = getDigitValueFromStack()
//        let test = {
//            completeDigitalValue - getDigitValueFromStack() == 0.0 ?
//                completeDigitalValue.toLong().toString() : completeDigitalValue.toString()
//        }
//        let curr: String = digitStack.isEmpty ? "" :
//
//        when {
//            lastOperator != null && lastOperand != null -> {
//                val template = activity.resources.getString(R.string.formula)
//                val tmp: Double = lastOperand ?: 0.0
//                val previous = if (tmp - tmp.toLong() == 0.0)
//                tmp.toLong().toString() else tmp.toString()
//                activity.formula.text = String.format(template, previous, lastOperator, curr)
//            }
//            lastOperand != null -> {
//                val tmp: Double = lastOperand ?: 0.0
//                val cleanLast: String = if (tmp - tmp.toLong() == 0.0)
//                tmp.toLong().toString() else tmp.toString()
//                activity.formula.text = cleanLast
//            }
//            else -> activity.formula.text = curr
//        }
    }
    
    private func refreshResultView(value: Double) {
        
    }
    
    func genericDigitListener(digit: Double) {
        
    }
}
