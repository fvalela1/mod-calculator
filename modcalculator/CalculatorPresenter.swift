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
    func calculationDidSucceed()
    func calculationDidFailed(message: String)
}

class CalculatorPresenter {

    weak var delegate: CalculatorDelegate?
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
 
    func pushOperator(op: String) {

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
    
    
    private func refreshFormulaView() {
        let completeDigitalValue = getDigitValueFromStack()
        let curr: String = digitStack.isEmpty ? "" : String(completeDigitalValue)

        switch (lastOperator != nil && lastOperand != nil) {
        case true:
            return //temporary
            //TODO Look into this portion and understasnd logic
//            let template = activity.resources.getString(R.string.formula)
//            let tmp: Double = lastOperand ?? 0.0
//            let previous = tmp.toString()
//            activity.formula.text = String.format(template, previous, lastOperator, curr)
        case false:
            if lastOperand != nil  {
                //may be broken, need to check how many decimals are needed (if any are needed at all)
                let cleanLast: String = String(format: "%.16f", lastOperand ?? " ")
                //TODO make textview from view controller = cleanLast
            } else {
                //TODO make textview from view controller = curr
            }
        }
    }
    
    //TODO
    private func refreshResultView(value: Double) {
        //refresh view from view controller
    }
    
    func genericDigitListener(digit: Double) {
        if(lastOperator == nil) {
            calc.clear()
            lastOperand = nil
        }
        digitStack.push(digit)
        refreshFormulaView()
    }
    
}
