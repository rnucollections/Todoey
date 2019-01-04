//
//  ViewController.swift
//  Todoey
//
//  Created by Reshmi Kalpavraksh on 1/4/19.
//  Copyright © 2019 Reshmi Kalpavraksh. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    let itemArray = ["Find Mike", "Buy Eggs", "Destroy Demodragon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
//
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
//    }

}
