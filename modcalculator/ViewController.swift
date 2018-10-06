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
    let calculateTextView: UITextView = {
        let textView = UITextView()
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
        let numbersStackView = makeVerticalNumberStackView()
        let operatorStackView = makeOperatorsStackView()
        self.view.addSubview(numbersStackView)
        self.view.addSubview(operatorStackView)
        self.view.addSubview(calculateTextView)
        NSLayoutConstraint.activate([
            calculateTextView.topAnchor.constraint(equalTo: self.view.topAnchor),
            calculateTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            calculateTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            calculateTextView.bottomAnchor.constraint(equalTo: numbersStackView.topAnchor),
            //MARK: operator stack view constraints
            operatorStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            operatorStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            operatorStackView.topAnchor.constraint(equalTo: self.view.centerYAnchor),
            operatorStackView.widthAnchor.constraint(equalToConstant: self.view.frame.width/6),
            //MARK: numbers stack view constraints
            numbersStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            numbersStackView.rightAnchor.constraint(equalTo: operatorStackView.leftAnchor),
            numbersStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            numbersStackView.topAnchor.constraint(equalTo: self.view.centerYAnchor)
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
    
    @objc func onNumberTapped(_ sender: UIButton) {
        switch sender.tag {
        case (CalculatorKey.zero.rawValue)...(CalculatorKey.nine.rawValue):
            let pressedNumber = (sender.tag)
            presenter?.genericDigitListener(digit: Double(pressedNumber))
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
    
    //make array of UIButton, add them to the UIStackView and returns the UIStackView.
    private func makeOperatorsStackView() -> UIStackView {
        let titles = ["←", "c", "%" , "="]
        var operatorButtons = [UIButton]()
        var tag = 11
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
}

extension ViewController: CalculatorDelegate, UITextViewDelegate {
    func buttonDidTap(_ value: Int) {
        print("button pressed \(value)")
    }
    
    func calculationDidSucceed() {
        
    }
    
    func calculationDidFailed(message: String) {
        
    }
}


