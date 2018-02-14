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
    
    // Creating a Codable plist file Path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Shoshana.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
            let newItem : Item = Item()
            newItem.title = textField.text!
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
        
        // Create an Encoder
        let encoder : PropertyListEncoder = PropertyListEncoder()
        do {
            // Encoding the Arraylist to a dictionary plist file
            let data = try encoder.encode(itemArray)
            
            // Writing our to a data custom file
            try data.write(to: dataFilePath!)
        } catch {
            print("Error saving item array: \(error)")
        }
    }
    
    func loadItems() {
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder : PropertyListDecoder = PropertyListDecoder()
            
            // This is the method that decodes out data,
            // we have to specify what is the data type of the doceded value.
            // Out data is Array of Item [Item]. we have to add the .self
            // so it will know that we are referring to out Item type and not an Object
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item Array : \(error)")
        }
        
//        if let dataTwo = try? Data(contentsOf: dataFilePath!) {
//            let decoderTwo : PropertyListDecoder = PropertyListDecoder()
//            do {
//                itemArray = try decoderTwo.decode([Item].self, from: dataTwo)
//            } catch {
//                print("Error decoding Item Array: \(error)")
//            }
//        }
    }
}
