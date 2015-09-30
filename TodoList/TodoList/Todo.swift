//
//  Todo.swift
//  Capacitor
//
//  Created by Eli Perkins on 9/10/15.
//  Copyright © 2015 Venmo. All rights reserved.
//

import Foundation

struct Todo: Equatable {
    let id: NSUUID
    let text: String
    let complete: Bool
}

func ==(lhs: Todo, rhs: Todo) -> Bool {
    return lhs.id == rhs.id && lhs.text == rhs.text && lhs.complete == rhs.complete
}

extension Todo: Hashable {
    var hashValue: Int {
        return id.hashValue ^ text.hashValue ^ complete.hashValue
    }
}

struct TodoList: Equatable {
    let todos: [Todo]
}

func ==(lhs: TodoList, rhs: TodoList) -> Bool {
    return lhs.todos == rhs.todos
}

extension TodoList: Hashable {
    var hashValue: Int {
        return todos.reduce(0) {
            return $0 ^ $1.hashValue
        }
    }
}
