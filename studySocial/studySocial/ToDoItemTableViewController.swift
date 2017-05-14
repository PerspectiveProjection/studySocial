//
//  ToDoItemTableViewController.swift
//  studySocial
//
//  Created by Elizabeth Kelly on 5/13/17.
//  Copyright © 2017 perspectiveProjection. All rights reserved.
//

import UIKit
import Firebase

class ToDoItemTableViewController: UITableViewController {
    var items: [Todo] = []
    var ref = FIRDatabase.database().reference(withPath: "toDoItems")
	var userDefaults : UserDefaults!
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
        self.ref.observe(.value, with: { snapshot in
            var newItems: [Todo] = []
            
            for item in (snapshot.children) {
				//let itemComparison = Todo(snapshot: item as! FIRDataSnapshot)
				//if(itemComparison["userEmail"] as! String == self.userDefaults.object(forKey: "userEmail") as! String) {
				let currentToDo = Todo(snapshot: item as! FIRDataSnapshot)
				if(currentToDo.getEmail() == self.userDefaults.object(forKey: "userEmail") as! String) {
					newItems.append(Todo(snapshot: item as! FIRDataSnapshot))
				}
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults = UserDefaults.standard
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ToDoItemTableViewController.addTodoItemButton))
        self.navigationItem.rightBarButtonItem = addButton
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func addTodoItemButton() {
        let alertController = UIAlertController(title: "Add Item", message: "Please Enter a Todo Item", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) -> Void in
            let field = alertController.textFields![0]
			let userEmail = self.userDefaults.object(forKey: "userEmail") as! String
			let todoItem = Todo(item: (field.text)!, completed: false, userEmail: userEmail)
            let todoItemRef = self.ref.child(byAppendingPath: (field.text?.lowercased())!)
            todoItemRef.setValue(todoItem.toDict())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Todo Item"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func toggleCheckmark(_ cell: UITableViewCell, completed: Bool) {
        if completed {
            cell.textLabel?.textColor = UIColor.gray
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].item
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items[indexPath.row].firebaseRef.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let toggledCompletion = !items[indexPath.row].completed
        toggleCheckmark(cell!, completed: toggledCompletion)
        items[indexPath.row].firebaseRef.updateChildValues(["completed": toggledCompletion])
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(itemToMove, at: destinationIndexPath.row)
    }
    
}
