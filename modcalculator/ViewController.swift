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
    //MARK: UI Elements
    let calculateTextView: UITextField = {
        let textView = UITextField()
        textView.backgroundColor = .green
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let backspaceButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("c", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let equalsButton: UIButton = {
        let button = UIButton()
        button.setTitle("=", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let modButton: UIButton = {
        let button = UIButton()
        button.setTitle("mod", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
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
        case mod
        case equal
    }
 
    //MARK: - setup views
    fileprivate func setupViews() {
        self.view.addSubview(stackView)
        let wholeStackView = makeVerticalStackView()
        self.view.addSubview(wholeStackView)
        self.view.addSubview(calculateTextView)
        NSLayoutConstraint.activate([
            calculateTextView.topAnchor.constraint(equalTo: self.view.topAnchor),
            calculateTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            calculateTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            calculateTextView.bottomAnchor.constraint(equalTo: wholeStackView.topAnchor)
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
        button.tag = counter
        button.addTarget(self, action: #selector(onNumberButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    
    @objc func onNumberButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case (CalculatorKey.zero.rawValue)...(CalculatorKey.nine.rawValue):
            let pressedNumber = sender.tag
            service.pushOperand(operand: Double(pressedNumber))
        case (CalculatorKey.clear.rawValue):
            service.clear()
        case (CalculatorKey.mod.rawValue):
            //FIXME: fix the numbers
            let output = service.mod(num1: 5, num2: 3)
            print(output)
        case (CalculatorKey.delete.rawValue):
            service.undo()
        case (CalculatorKey.equal.rawValue):
            let output = service.recalculate()
            print(output)
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
}

extension ViewController: CalculatorDelegate{
    func calculationDidSucceed() {
        
    }
    
    func calculationDidFailed(message: String) {
        
    }
}


