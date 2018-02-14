//
//  ToDoListViewControllers.swift
//  Todoey
//
//  Created by Matan Dahan on 11/02/2018.
//  Copyright © 2018 Matan Dahan. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray : [Item] = [Item]()
    
    // Setting the refrence to UserDefaults
    let defaults = UserDefaults.standard
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Shoshana.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(path!)
        
        let newItem : Item = Item()
        newItem.title = "Liraz"
        itemArray.append(newItem)
        
        let newItem2 : Item = Item()
        newItem2.title = "David"
        itemArray.append(newItem2)
        
        let newItem3 : Item = Item()
        newItem3.title = "Matan"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item : Item = itemArray[indexPath.row]
        
        // Because the itemArray is now an Item and not a String
        cell.textLabel?.text = item.title
        
        // Ternary Operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(itemArray[indexPath.row]) at Row: \(indexPath.row)")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // Change Appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // var to save the text from popup
        var textField = UITextField()
        
        // Create popup alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        // Add textfield to popup alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // Create action to alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen when the user clicks on the Add button
            let newItem : Item = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // Saving to UserDefaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Load the data we added to the tableview
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
