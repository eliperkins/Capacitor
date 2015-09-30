//
//  TodoAction.swift
//  Capacitor
//
//  Created by Eli Perkins on 9/10/15.
//  Copyright © 2015 Venmo. All rights reserved.
//

import Capacitor

struct AppAction: Action {
    let source: String
    let action: TodoAction
}

enum TodoAction {
    case Create(String)
    case Update(NSUUID, String?, Bool?)
    case Destroy(NSUUID)
}
