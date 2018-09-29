//
//  ViewController.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-17.
//  Copyright © 2018 Francesco Valela. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    var stack = Stack<Calculator>()
    var currentOperand = "0"
    //MARK: UI Elements
    let calculateTextField: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .black
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        textView.textAlignment = .right
        textView.text = "0"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let backspaceButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.tag = 12
        button.addTarget(self, action: #selector(onNumberButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("c", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.tag = 11
        button.addTarget(self, action: #selector(onNumberButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let equalsButton: UIButton = {
        let button = UIButton()
        button.setTitle("=", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.tag = 14
        button.addTarget(self, action: #selector(onNumberButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let modButton: UIButton = {
        let button = UIButton()
        button.setTitle("mod", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.tag = 13
        button.addTarget(self, action: #selector(onNumberButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView : UIStackView = {
        let SV = UIStackView(arrangedSubviews: [clearButton,backspaceButton,modButton, equalsButton])
        SV.axis = .vertical
        SV.distribution = .fillEqually
        SV.backgroundColor = .yellow
        SV.translatesAutoresizingMaskIntoConstraints = false
        return SV
    }()
    
    var presenter: CalculatorPresenter?
    
    enum CalculatorKey: Int {
        case zero = 1
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
        case mod //make this equal to the unicode number for mod
        case equal
    }
    
    //MARK: - setup views
    fileprivate func setupViews() {
        self.view.addSubview(stackView)
        let wholeStackView = makeVerticalStackView()
        self.view.addSubview(wholeStackView)
        self.view.addSubview(calculateTextField)
        NSLayoutConstraint.activate([
            calculateTextField.topAnchor.constraint(equalTo: self.view.topAnchor),
            calculateTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            calculateTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            calculateTextField.bottomAnchor.constraint(equalTo: wholeStackView.topAnchor)
            ])
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width/6)
            ])
        NSLayoutConstraint.activate([
            wholeStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            wholeStackView.rightAnchor.constraint(equalTo: self.stackView.leftAnchor),
            wholeStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            wholeStackView.topAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.presenter = CalculatorPresenter(delegate: self)
        setupViews()
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
        largeContainerSV.addArrangedSubview(makeStackView(from: buttons))
        
        return makeHorizontalStackView(count: count-3, largeContainerSV: &largeContainerSV)
    }
    
    
    private func makeButton(from counter: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(String(counter), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.tag = counter
        button.addTarget(self, action: #selector(onNumberButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    
    @objc func onNumberButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case (CalculatorKey.zero.rawValue)...(CalculatorKey.nine.rawValue):
            let pressedNumber = (sender.tag)
            presenter?.genericDigitListener(digit: Double(pressedNumber))
        case (CalculatorKey.clear.rawValue):
            presenter?.clear()
        case (CalculatorKey.mod.rawValue):
            // convert Int to a valid UnicodeScalar
            guard let unicodeScalar = UnicodeScalar(sender.tag) else {
                return
            }
            presenter?.pushOperator(op: Character(unicodeScalar))
        case (CalculatorKey.delete.rawValue):
            presenter?.undo()
        case (CalculatorKey.equal.rawValue):
            presenter?.equals()
        default:
            break
        }
    }
    
    private func makeStackView(from buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func makeVerticalStackView() -> UIStackView {
        var largeStackView = UIStackView()
        largeStackView.axis = .vertical
        largeStackView.distribution = .fillEqually
        largeStackView.translatesAutoresizingMaskIntoConstraints = false
        largeStackView.backgroundColor = .black
        largeStackView = makeHorizontalStackView(count: 9, largeContainerSV: &largeStackView)
        return largeStackView
    }
    
    // Contacnates numbers until user hit an operator button.
    private func getStoredOperand(from value: Int) -> String {
        let operand = "\(value)"
        if currentOperand == "0" {
            currentOperand = operand
        } else {
            currentOperand += operand
        }
        return currentOperand
    }
}

extension ViewController: CalculatorDelegate {
    func calculationDidSucceed() {
        
    }
    
    func calculationDidFailed(message: String) {
        
    }
}


