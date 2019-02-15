//
//  TodoDetailViewController.swift
//  RWTableView
//
//  Created by Jaspal on 2/13/19.
//  Copyright © 2019 Jaspal Suri. All rights reserved.
//

import UIKit

protocol todoDetailViewControllerDelegate: class {
    
    func todoDetailViewControllerDidCancel(_ controller: TodoDetailViewController)
    func todoDetailViewController(_ controller: TodoDetailViewController, didFinishAdding todo: ChecklistTodo)
    func todoDetailViewController(_ controller: TodoDetailViewController, didFinishEditing todo: ChecklistTodo)
    
}

class TodoDetailViewController: UITableViewController {
    
    weak var delegate: todoDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var todoToEdit: ChecklistTodo?
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.todoDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let todo = todoToEdit, let text = addTodoTextField.text {
            todo.text = text
            delegate?.todoDetailViewController(self, didFinishEditing: todo)
        } else {
            if let todo = todoList?.newTodo() {
                if let todoText = addTodoTextField.text {
                    todo.text = todoText
                }
                todo.isTaskCompleted = .incomplete
                delegate?.todoDetailViewController(self, didFinishAdding: todo)
            }
        }
    }
    @IBOutlet weak var addTodoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todoToEdit {
            title = "Edit Todo"
            addTodoTextField.text = todo.text
            doneBarButton.isEnabled = true
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addTodoTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}

// extensions are a great way to group all of your delegate methods
extension TodoDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTodoTextField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = addTodoTextField.text,
            let stringRange = Range(range, in: oldText)
            else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        // check if text is empty
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
}
