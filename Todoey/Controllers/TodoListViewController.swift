//
//  ViewController.swift
//  Todoey
//
//  Created by Reshmi Kalpavraksh on 1/4/19.
//  Copyright © 2019 Reshmi Kalpavraksh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()

    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.backgroundColor else {fatalError()}
        
        title = selectedCategory!.name
        updateNavBar(withHexCode: colourHex)

    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        updateNavBar(withHexCode: "ID9BF6")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    //MARK - TableView Configuration
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


