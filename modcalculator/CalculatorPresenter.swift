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
    
    func clear(){

    }
    
    func equals() {
        
    }
    
    func undo() {
        
    }
    
    func mod(num1: Double, num2: Double) {
   
    }
    
    func pushOperator(op: String) {

    }
    
    private func refreshFormulaView() {
        
    }
    
    private func refreshResultView(value: Double) {
        
    }
    
    func genericDigitListener(digit: Double) {
        
    }
}
