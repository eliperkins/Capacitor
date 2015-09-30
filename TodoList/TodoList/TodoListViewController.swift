//
//  TodoListViewController.swift
//  Capacitor
//
//  Created by Eli Perkins on 9/13/15.
//  Copyright © 2015 Venmo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var todoList: TodoList {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(todoList: TodoList) {
        self.todoList = todoList
        super.init(style: .Plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let todo = todoList.todos[indexPath.row]
        cell.textLabel?.text = todo.text
        cell.textLabel?.textColor = todo.complete ? .grayColor() : .blackColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let todo = todoList.todos[indexPath.row]
        toggleComplete(todo)
    }
    
    func add(sender: UIBarButtonItem) {
        dispatcher.dispatch(AppAction(source: "view", action: TodoAction.Create("new action")))
    }
    
    func toggleComplete(todo: Todo) {
        dispatcher.dispatch(AppAction(source: "view", action: TodoAction.Update(todo.id, nil, !todo.complete)))
    }
    
    func remove(todo: Todo) {
        dispatcher.dispatch(AppAction(source: "view", action: TodoAction.Destroy(todo.id)))
    }
}
