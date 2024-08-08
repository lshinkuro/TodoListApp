//
//  ViewController.swift
//  TodoListApp
//
//  Created by Phincon on 08/08/24.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    var tasks: [Task] = []
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.fetchTasks()
    }
    
    @IBAction func addTaskButton(_ sender: Any) {
        addTask()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
    }
}

extension ViewController {
    @objc func addTask() {
          let alert = UIAlertController(title: "New Task", message: "Enter task title", preferredStyle: .alert)
          alert.addTextField()
          let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
              guard let title = alert.textFields?.first?.text, !title.isEmpty else { return }
              CoreDataManager.shared.addTask(title: title)
              self?.fetchTasks()
          }
          alert.addAction(addAction)
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          present(alert, animated: true)
      }
    
    func showEditTaskAlert(task: Task) {
          let alert = UIAlertController(title: "Edit Task", message: "Update task title", preferredStyle: .alert)
          alert.addTextField { textField in
              textField.text = task.title
          }
          let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
              guard let newTitle = alert.textFields?.first?.text, !newTitle.isEmpty else { return }
              CoreDataManager.shared.editTask(task: task, newTitle: newTitle)
              self?.fetchTasks()
          }
          alert.addAction(saveAction)
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          present(alert, animated: true)
      }

      func fetchTasks() {
          tasks = CoreDataManager.shared.fetchTasks()
          tableView.reloadData()
      }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
         cell.titleLabel.text = task.title
         cell.completedButton.setTitle(task.isCompleted ? "✅" : "⬜️", for: .normal)
         cell.toggleCompletion = {
             CoreDataManager.shared.toggleTaskCompletion(task: task)
             self.tableView.reloadRows(at: [indexPath], with: .automatic)
         }
        return cell
      }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            CoreDataManager.shared.deleteTask(task: taskToDelete)
            fetchTasks()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        showEditTaskAlert(task: task)
        
    }
}


