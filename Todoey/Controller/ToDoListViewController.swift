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
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // Create the context from AppDelegate Singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray : [Item] = [Item]()
    
    // Creating a Codable plist file Path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Shoshana.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        //Deleting from the database
//        context.delete(itemArray[indexPath.row])
//        
//        //Deleting from the UI List
//        itemArray.remove(at: indexPath.row)
        
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
            newItem.parentCategory = self.selectedCategory
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
        
        tableView.reloadData()
    }
    
    // this function is asking for q request, if you don't give her any request
    // it will get the default paramenter we gave it.
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), itemPredicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = itemPredicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        // You have to specify the data type of the request and the Entity type.
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error Fetching Data from context: \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - SearchBar Delegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            // sortDescriptor - it wants an array of sortDescriptors
            // but we only have one so we wrap it in an array.
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, itemPredicate: predicate)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            
            // Going into the main thread and activating the function that
            // make the keyboard disapear Asynchronised.
            // that way you don't need to wait for the Threads to finish
            // and wait for the queue.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
    }
    
}
