//
//  ViewController.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-17.
//  Copyright © 2018 Francesco Valela. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    let equalsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let modButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(equalsButton)
        self.view.addSubview(modButton)
        NSLayoutConstraint.activate([
            equalsButton.topAnchor.constraint(equalTo: self.view.topAnchor),
            equalsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            equalsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            equalsButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])
        NSLayoutConstraint.activate([
            modButton.topAnchor.constraint(equalTo: self.view.topAnchor),
            modButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            modButton.rightAnchor.constraint(equalTo: self.equalsButton.leftAnchor),
            modButton.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            ])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

