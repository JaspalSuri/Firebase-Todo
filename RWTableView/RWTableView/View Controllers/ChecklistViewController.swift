//
//  ChecklistViewController.swift
//  RWTableView
//
//  Created by Jaspal on 2/11/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

class ChecklistViewController: UITableViewController {

    let tableCellReuseIdentifier = "ChecklistTodo"
//    let checklistTodo = ChecklistTodo()
    
    var todoList: TodoList
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    // called when a view controller is initialized from the storyboard
    required init?(coder aDecoder: NSCoder) {
    
        todoList = TodoList()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    @IBAction func addTodo(_ sender: Any) {
        
        // Set todo list size
        let newRowIndex = todoList.todoList(for: .medium).count
        // This tells the compiler that we're not interested in the object returned from this method
        let _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        
        // How to update the tableView with an animation
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        // Interferes with the checkmarks being properly applied
        // tableView.reloadData()
    }
    
    @IBAction func deleteTodos(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList.todoList(for: priority)
                    
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    
                    let item = todos[rowToDelete]
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    

    // returns NUMBER of ROWS
    // return 1 row per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
        return 0
    }
    
    // Called every time a table row needs a cell and can be customized
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tableView is part of the storyboard
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath)
        // let todo = todoList.todos[indexPath.row]
        
        if let priority = priorityForSectionIndex(indexPath.section) {
            let todos = todoList.todoList(for: priority)
            let todo = todos[indexPath.row]
            // Displays the todo's text
            configureText(for: cell, with: todo)
            // Shows a checkmark if the todo is complete
            configureCheckmark(for: cell, with: todo)
        }
        
        return cell
    }

    // When the user interacts with a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let todos = todoList.todoList(for: priority)
                let todo = todos[indexPath.row]
                // 'Toggle' the check mark
                todo.toggleCompletion()
                
                configureCheckmark(for: cell, with: todo)
                
                // Disables highlight after the user taps on a cell
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // Remove/delete cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let priority = priorityForSectionIndex(indexPath.section) {
            let todo = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(todo, from: priority, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Rearrange table cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      //  todoList.move(todo: todoList.todoList[sourceIndexPath.row], to: destinationIndexPath.row)

        if let sourcePriority = priorityForSectionIndex(sourceIndexPath.section),
            let destinationPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let todo = todoList.todoList(for: sourcePriority)[sourceIndexPath.row]
            todoList.move(todo: todo, from: sourcePriority, at: sourceIndexPath.row, to: destinationPriority, at: destinationIndexPath.row)
        }
        
        tableView.reloadData()
    }
    
    // Do a lookup once and then pass in a checklist item
    func configureText(for cell: UITableViewCell, with todo: ChecklistTodo) {
        if let checkMarkCell = cell as? ChecklistTableViewCell {
            checkMarkCell.todoTextLabel.text = todo.text
        }
    }

    // Set the check mark based on the state of completion
    func configureCheckmark(for cell: UITableViewCell, with todo: ChecklistTodo) {
        guard let checkMarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        
        if todo.isTaskCompleted == .incomplete {
            // Options: ✔️ | √ (via option + V) | ✓
            checkMarkCell.checkMarkLabel.text = ""
        // purposeful redundancy for clarity
        } else if todo.isTaskCompleted == .complete {
            checkMarkCell.checkMarkLabel.text = "✓"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTodoSegue" {
            // Creates a blank vc that's based off of the add todo table vc
            if let todoDetailViewController = segue.destination as? TodoDetailViewController {
                todoDetailViewController.delegate = self
                todoDetailViewController.todoList = todoList
            }
        } else if segue.identifier == "EditTodoSegue" {
            if let todoDetailViewController = segue.destination as? TodoDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section)
                    {
                        
                    let todo = todoList.todoList(for: priority)[indexPath.row]
                    todoDetailViewController.todoToEdit = todo
                    todoDetailViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    override  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority Todos"
            case .medium:
                title = "Medium Priority Todos"
            case .low:
                title = "Low Priority Todos"
            case .no:
                title = "Someday Todo Items"
            }
        }
        return title
    }
    @IBAction func signOutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    

    
}

extension ChecklistViewController: todoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidCancel(_ controller: TodoDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func todoDetailViewController(_ controller: TodoDetailViewController, didFinishAdding todo: ChecklistTodo) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func todoDetailViewController(_ controller: TodoDetailViewController, didFinishEditing todo: ChecklistTodo) {
        
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.index(of: todo) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: todo)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
