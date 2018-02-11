//
//  ToDoListViewControllers.swift
//  Todoey
//
//  Created by Matan Dahan on 11/02/2018.
//  Copyright © 2018 Matan Dahan. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray : [String] = ["Shoshana", "Damari", "Ofra Haza"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(itemArray[indexPath.row]) at Row: \(indexPath.row)")
        
        // Add Checkbox to the selected cell
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        // Change Appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
