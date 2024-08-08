//
//  CoreDataManager.swift
//  TodoListApp
//
//  Created by Phincon on 08/08/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Fetch tasks
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    // Add task
    func addTask(title: String) {
        let newTask = Task(context: context)
        newTask.title = title
        newTask.isCompleted = false
        saveContext()
    }

    // Delete task
    func deleteTask(task: Task) {
        context.delete(task)
        saveContext()
    }

    // Toggle task completion
    func toggleTaskCompletion(task: Task) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    // Edit task
     func editTask(task: Task, newTitle: String){
         task.title = newTitle
         saveContext()
     }
}

enum CoreDataResult {
    case added, failed, deleted, updated
}

