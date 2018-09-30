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
    fileprivate var service = CalculatorService()
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
    var presenter: CalculatorPresenter?
    var currentOperand = "0"
    
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
    
    
    //MARK: - setup views
    fileprivate func setupViews() {
        let wholeStackView = makeVerticalStackView()
        let operatorStackView = makeOperatorsStackView()
        self.view.addSubview(wholeStackView)
        self.view.addSubview(operatorStackView)
        self.view.addSubview(calculateTextField)
        NSLayoutConstraint.activate([
            calculateTextField.topAnchor.constraint(equalTo: self.view.topAnchor),
            calculateTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            calculateTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            calculateTextField.bottomAnchor.constraint(equalTo: wholeStackView.topAnchor)
            ])
        NSLayoutConstraint.activate([
            operatorStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            operatorStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            operatorStackView.topAnchor.constraint(equalTo: self.view.centerYAnchor),
            operatorStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width/6)
            ])
        NSLayoutConstraint.activate([
            wholeStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            wholeStackView.rightAnchor.constraint(equalTo: operatorStackView.leftAnchor),
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
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onNumberTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .black
        button.tag = counter
        return button
    }
    
    @objc func onNumberTapped(_ sender: UIButton) {
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
    
    //make array of UIButton, add them to the UIStackView and returns the UIStackView.
    private func makeOperatorsStackView() -> UIStackView {
        let titles = ["←", "c", "mod" , "="]
        var operatorButtons = [UIButton]()
        for eachTitle in titles {
            let button = UIButton()
            button.setTitle(eachTitle, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.translatesAutoresizingMaskIntoConstraints = false
            operatorButtons.append(button)
        }
        let operatorStackView = UIStackView(arrangedSubviews: operatorButtons)
        operatorStackView.axis = .vertical
        operatorStackView.distribution = .fillEqually
        operatorStackView.translatesAutoresizingMaskIntoConstraints = false
        return operatorStackView
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
}

extension ViewController: CalculatorDelegate {
    func buttonDidTap(_ value: Int) {
        print("button pressed \(value)")
    }
    
    func calculationDidSucceed() {
        
    }
    
    func calculationDidFailed(message: String) {
        
    }
}


