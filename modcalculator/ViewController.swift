//
//  ViewController.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-17.
//  Copyright © 2018 Francesco Valela. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func makeHorizontalStackView(count: Int, largeContainerSV: inout UIStackView) -> UIStackView {
        
        if (count < 0) {
            return largeContainerSV
        }
        
        var buttons = [UIButton]()
        
        for eachCounter in count-2...count {
            if (eachCounter < 0) { continue }
            let button = UIButton()
            button.setTitle(String(eachCounter), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .yellow
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        largeContainerSV.addArrangedSubview(stackView)
        
        return makeHorizontalStackView(count: count-3, largeContainerSV: &largeContainerSV)
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
