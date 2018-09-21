//
//  Stack.swift
//  modcalculator
//
//  Created by Francesco Valela on 2018-09-21.
//  Copyright © 2018 Francesco Valela. All rights reserved.
//

import Foundation

struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    var size: Int {
        return items.count
    }
    var peek: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
