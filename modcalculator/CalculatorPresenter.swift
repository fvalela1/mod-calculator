//
//  NumberCruncherPresenter.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-24.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

//put functions that the presenter will call to access VC
protocol CalculatorDelegate {
    func calculationDidSucceed()
    func calculationDidFailed(message: String)
}

class CalculatorPresenter {
    var delegate: CalculatorDelegate
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }
    
    func clear() {
        
    }
    
    func equals() {
        
    }
    
    func undo() {
        
    }
    
    func pushOperator(op: String) {
        
    }
    
    private func getDigitValueFromStack() -> Double {
        return Double.nan
    }
    
    private func refreshFormulaView() {
        
    }
    
    private func refreshResultView(value: Double) {
        
    }
    
    func genericDigitListener(digit: Double) {
        
    }
}
