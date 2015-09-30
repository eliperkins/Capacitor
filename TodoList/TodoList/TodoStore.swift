//
//  TodoStore.swift
//  Capacitor
//
//  Created by Eli Perkins on 9/10/15.
//  Copyright © 2015 Venmo. All rights reserved.
//

import Capacitor

class TodoStore: ReduceStore<TodoList, AppAction> {
    override init(dispatcher: Dispatcher<AppAction>, initialState: TodoList) {
        super.init(dispatcher: dispatcher, initialState: initialState)
    }
    
    override func reduce(state: TodoList, action: AppAction) -> TodoList {
        switch action.action {
        case .Create(let text):
            let todo = Todo(id: NSUUID(), text: text, complete: false)
            return TodoList(todos: state.todos + [todo])

        case .Update(let id, let text, let completed):
            guard let todoIndex = state.todos.indexOf({ $0.id == id }) else { return state }
            let todo = state.todos[todoIndex]
            var todos = state.todos
            todos.removeAtIndex(todoIndex)
            let newTodo = Todo(id: id, text: text ?? todo.text, complete: completed ?? todo.complete)
            todos.insert(newTodo, atIndex: todoIndex)
            return TodoList(todos: todos)

        case .Destroy(let id):
            return TodoList(todos: state.todos.filter { $0.id != id })
        }
    }
}
