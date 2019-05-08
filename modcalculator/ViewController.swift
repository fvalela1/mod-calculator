//
//  ViewController.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-17.
//  Copyright © 2018 Francesco Valela. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    var presenter: CalculatorPresenter?
    var resultTextView: UITextView?
    var formulaTextView: UITextView?
    
    enum CalculatorKey: Int {
        case zero = 0
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case clear
        case delete
        case mod
        case equal
    }
    
    //MARK: - setup views
    private func setupViews() {
        let calculationStackView = makeCalculationStackView()
        let numbersStackView = makeVerticalNumberStackView()
        let operatorStackView = makeOperatorsStackView()
        self.view.addSubview(numbersStackView)
        self.view.addSubview(operatorStackView)
        self.view.addSubview(calculationStackView)
        NSLayoutConstraint.activate([
            //MARK: calculation stack view constraints
            calculationStackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            calculationStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            calculationStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            calculationStackView.bottomAnchor.constraint(equalTo: numbersStackView.topAnchor),
            //MARK: operator stack view constraints
            operatorStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            operatorStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            //TODO: change  constant to a view divided number
            operatorStackView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            operatorStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width/6),
            //MARK: numbers stack view constraints
            numbersStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            numbersStackView.rightAnchor.constraint(equalTo: operatorStackView.leftAnchor),
            numbersStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            //TODO: change  constant to a view divided number
            numbersStackView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
            ])
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.presenter = CalculatorPresenter(delegate: self)
        setupViews()
    }
    
    //MARK: Creating and populating UI Elements
    private func makeCalculationStackView() -> UIStackView {
        let arrOfResultAndFormulaTextView = makeResultAndFormulaTextView()
        let calculationStackView = UIStackView(arrangedSubviews: arrOfResultAndFormulaTextView)
        calculationStackView.axis = .vertical
        calculationStackView.distribution = .fillEqually
        calculationStackView.translatesAutoresizingMaskIntoConstraints = false
        calculationStackView.backgroundColor = .black
        return calculationStackView
    }
    
    private func makeResultAndFormulaTextView() -> [UITextView] {
        let titles = ["_", "resultTextView", "formulaTextView"]
        var calculationTextViews = [UITextView]()
        for (index, _) in titles.enumerated() {
            let textView = UITextView()
            textView.backgroundColor = .black
            textView.textAlignment = .right
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            switch(index) {
            case (1):
                textView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                textView.textColor = .darkGray
                textView.text = "0"
                textView.textAlignment = .right
                self.resultTextView = textView
            case (2):
                textView.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
                textView.textColor = .lightGray
                textView.text = "0"
                self.formulaTextView = textView
            default:
                break
            }
            calculationTextViews.append(textView)
        }
        return calculationTextViews
    }
    
    private func makeHorizontalStackView(count: Int, largeContainerSV: inout UIStackView) -> UIStackView {
        if (count < 0) {
            return largeContainerSV
        }
        var buttons = [UIButton]()
        for eachCounter in count-2...count {
            if (eachCounter < 0) { continue }
            buttons.append(makeButton(from: eachCounter))
        }
        largeContainerSV.addArrangedSubview(makeHorizontalStackViewHelper(from: buttons))
        return makeHorizontalStackView(count: count-3, largeContainerSV: &largeContainerSV)
    }
    
    private func makeButton(from counter: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(String(counter), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onNumberTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .black
        button.tag = counter
        return button
    }
    
    //make array of UIButton, add them to the UIStackView and returns the UIStackView.
    private func makeOperatorsStackView() -> UIStackView {
        let titles = ["c", "←", "%" , "="]
        var operatorButtons = [UIButton]()
        var tag = 10
        for eachTitle in titles {
            let button = UIButton()
            button.setTitle(eachTitle, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.tag = tag
            button.addTarget(self, action: #selector(onNumberTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            operatorButtons.append(button)
            tag += 1
        }
        let operatorStackView = UIStackView(arrangedSubviews: operatorButtons)
        operatorStackView.axis = .vertical
        operatorStackView.distribution = .fillEqually
        operatorStackView.translatesAutoresizingMaskIntoConstraints = false
        return operatorStackView
    }
    
    private func makeHorizontalStackViewHelper(from buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func makeVerticalNumberStackView() -> UIStackView {
        var largeStackView = UIStackView()
        largeStackView.axis = .vertical
        largeStackView.distribution = .fillEqually
        largeStackView.translatesAutoresizingMaskIntoConstraints = false
        largeStackView.backgroundColor = .black
        largeStackView = makeHorizontalStackView(count: 9, largeContainerSV: &largeStackView)
        return largeStackView
    }
    
    private func getProperFormat(for value: Double) {
        
    }
    
    //MARK: button object functionality
    @objc func onNumberTapped(_ sender: UIButton) {
        switch sender.tag {
        case (0):
            let pressedNumber = (sender.tag)
            presenter?.genericDigitListener(digit: String(pressedNumber))
        case (CalculatorKey.one.rawValue)...(CalculatorKey.nine.rawValue):
            let pressedNumber = (sender.tag)
            presenter?.genericDigitListener(digit: String(pressedNumber))
        case (CalculatorKey.clear.rawValue):
            presenter?.clear()
        case (CalculatorKey.mod.rawValue):
            // convert Int to a valid UnicodeScalar
            presenter?.pushOperator(op: Character(sender.currentTitle!))
        case (CalculatorKey.delete.rawValue):
            presenter?.undo()
        case (CalculatorKey.equal.rawValue):
            presenter?.equals()
        default:
            break
        }
    }
}

extension ViewController: CalculatorDelegate, UITextViewDelegate {
    func resultsDidRefresh(value: Double) {
        if(value.isNaN) {
            self.resultTextView?.text = "Error!"
        } else {
            self.resultTextView?.text = value.getProperFormatForView()
        }
        
    }
    
    func formulaDidRefresh(value: Double) {
        if(value.isNaN) {
            self.formulaTextView?.text = "Error!"
        } else {
            self.formulaTextView?.text = value.getProperFormatForView()
        }
    }
    
    func formulaDidRefresh(value: (Double, Character, Double)) {
        self.formulaTextView?.text = "\(value.0.getProperFormatForView()) \(value.1) \(value.2.getProperFormatForView())"
    }
    
    func formulaDidRefresh(value: (Double,Character)) {
        self.formulaTextView?.text = "\(value.0.getProperFormatForView()) \(value.1)"
    }
    
    
    func buttonDidTap(_ value: Int) {
        print("button pressed \(value)")
    }
    
    func calculationDidSucceed() {
        
    }
    
    func calculationDidFailed(message: String) {
        
    }
}

extension Double {
    private func isWholeNumber() -> Bool {
        let tempNumber = floor(self)
        return tempNumber == self
    }
    
    func getProperFormatForView() -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        
        if self.isWholeNumber() {
            formatter.maximumFractionDigits = 0
        } else {
            formatter.maximumFractionDigits = 16
        }
        
        return formatter.string(from: NSNumber(value: self))!
    }
    
    
}
