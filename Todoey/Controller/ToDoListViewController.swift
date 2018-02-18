//
//  ToDoListViewControllers.swift
//  Todoey
//
//  Created by Matan Dahan on 11/02/2018.
//  Copyright © 2018 Matan Dahan. All rights reserved.
//
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    // Create the context from AppDelegate Singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray : [Item] = [Item]()
    
    // Creating a Codable plist file Path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Shoshana.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(itemArray[indexPath.row]) at Row: \(indexPath.row)")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Deleting from the database
        context.delete(itemArray[indexPath.row])
        
        //Deleting from the UI List
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
        
        // Change Appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
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
            let newItem : Item = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            // Load the data we added to the tableview
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems() {
        // You have to specify the data type of the request and the Entity type.
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error Fetching Data from context: \(error)")
        }
    }
}
