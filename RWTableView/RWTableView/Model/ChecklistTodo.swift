//
//  ChecklistTodo.swift
//  RWTableView
//
//  Created by Jaspal on 2/11/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//


// This represents the todo list item
import Foundation

class ChecklistTodo: NSObject {
    
    @objc var text: String = ""
    
    // the two-cased enum replaces the bool
    // task completed as in "is the task completed?"
    enum taskCompletionState: String {
        case incomplete = "unchecked"
        case complete = "checked"
    }
    // The variable needed in other classes to
    // use the enum
    var isTaskCompleted: taskCompletionState = .incomplete
    
    func toggleCompletion() {
        // Switch completion states as the user toggles the task as complete/incomplete
        isTaskCompleted = isTaskCompleted == .incomplete ? .complete : .incomplete
    }
}
