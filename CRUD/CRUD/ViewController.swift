//
//  ViewController.swift
//  CRUD
//
//  Created by Ian Castillo on 02/07/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var items: [String] = ["Item 1", "Item 2", "Item 3"]
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "List Manager"

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItem)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteSelectedItem)
        )
    }

    @objc func addItem() {
        let alert = UIAlertController(
            title: "Add Item",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Item name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let itemName = alert.textFields?.first?.text, !itemName.isEmpty {
                self.items.append(itemName)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func deleteSelectedItem() {
        guard let selectedIndexPath = selectedIndexPath else {
            let alert = UIAlertController(
                title: "No Item Selected",
                message: "Please select an item to delete.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        items.remove(at: selectedIndexPath.row)
        tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
        self.selectedIndexPath = nil
    }

    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    // UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
        let alert = UIAlertController(
            title: "Edit Item",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.text = self.items[indexPath.row]
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let updatedName = alert.textFields?.first?.text, !updatedName.isEmpty {
                self.items[indexPath.row] = updatedName
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
        }
        editAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}
