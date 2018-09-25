//
//  NumberCruncherPresenter.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-24.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

protocol CalculatorDelegate {
    func calculationDidSucceed()
    func calculationDidFailed(message: String)
}

class CalculatorPresenter {
    var delegate: CalculatorDelegate
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }
    
    func register(email: String, password: String, fullName: String, phoneNumber:String){
    }
}
