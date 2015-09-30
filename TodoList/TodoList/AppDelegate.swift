//
//  AppDelegate.swift
//  TodoList
//
//  Created by Eli Perkins on 9/10/15.
//  Copyright © 2015 Venmo. All rights reserved.
//

import UIKit
import Capacitor

let dispatcher = Dispatcher<AppAction>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    var todoItemStore: ReduceStore<TodoList, AppAction>!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let todos = [Todo(id: NSUUID(), text: "Pick up laundry", complete: false)]
        todoItemStore = TodoStore(dispatcher: dispatcher, initialState: TodoList(todos: todos))
        
        let viewController = TodoListViewController(todoList: todoItemStore.state)
        todoItemStore.addChangeListener { store in
            if let store = store as? ReduceStore<TodoList, AppAction> {
                viewController.todoList = store.state
            }
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
