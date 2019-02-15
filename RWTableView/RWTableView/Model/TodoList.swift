//
//  TodoList.swift
//  RWTableView
//
//  Created by Jaspal on 2/11/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import Foundation

class TodoList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [ChecklistTodo] = []
    private var mediumPriorityTodos: [ChecklistTodo] = []
    private var lowPriorityTodos: [ChecklistTodo] = []
    private var noPriorityTodos: [ChecklistTodo] = []
    
    init() {
        
        let row0Todo = ChecklistTodo()
        let row1Todo = ChecklistTodo()
        let row2Todo = ChecklistTodo()
        let row3Todo = ChecklistTodo()
        let row4Todo = ChecklistTodo()
        let row5Todo = ChecklistTodo()
        let row6Todo = ChecklistTodo()
        let row7Todo = ChecklistTodo()
        let row8Todo = ChecklistTodo()
        let row9Todo = ChecklistTodo()
        
        row0Todo.text = "Take a jog"
        row1Todo.text = "Watch a movie"
        row2Todo.text = "Code an app"
        row3Todo.text = "Walk the dog"
        row4Todo.text = "Study design patterns"
        row5Todo.text = "Go camping"
        row6Todo.text = "Pay bills"
        row7Todo.text = "Plan vacation"
        row8Todo.text = "Walk the cat"
        row9Todo.text = "Play games"
        
        addTodo(row0Todo, for: .medium)
        addTodo(row1Todo, for: .low)
        addTodo(row2Todo, for: .high)
        addTodo(row3Todo, for: .no)
        addTodo(row4Todo, for: .high)
        addTodo(row5Todo, for: .medium)
        addTodo(row6Todo, for: .low)
        addTodo(row7Todo, for: .high)
        addTodo(row8Todo, for: .no)
        addTodo(row9Todo, for: .high)

        
    }
    
    func addTodo(_ todo: ChecklistTodo, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTodos.append(todo)
            } else {
                highPriorityTodos.insert(todo, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTodos.append(todo)
            } else {
                mediumPriorityTodos.insert(todo, at: index)
            }
        case .low:
            if index < 0 {
                lowPriorityTodos.append(todo)
            } else {
                lowPriorityTodos.insert(todo, at: index)
            }
        case .no:
            if index < 0 {
                noPriorityTodos.append(todo)
            } else {
                noPriorityTodos.insert(todo, at: index)
            }
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistTodo] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }
    
    func newTodo() -> ChecklistTodo {
        let todo = ChecklistTodo()
        todo.text = randomTitle()
        todo.isTaskCompleted = .complete
        mediumPriorityTodos.append(todo)
        return todo
        
    }
    
    func move(todo: ChecklistTodo, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(todo, from: sourcePriority, at: sourceIndex)
        addTodo(todo, for: destinationPriority, at: destinationIndex)
    }
    
    func remove(_ todo: ChecklistTodo, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }

    private func randomTitle() -> String {
        
        var titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
        let randomNumber = Int.random(in: 0 ... titles.count - 1)
        return titles[randomNumber]
    }
}

