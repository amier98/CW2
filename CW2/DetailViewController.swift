//
//  DetailViewController.swift
//  CW2
//
//  Created by amier ali on 22/04/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
import CoreData
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var currentTask:Task?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cellcolour:UIColor = UIColor(red: 0.0 , green: 1.0, blue: 0.0, alpha: 0.1)
    let cellSelcolour:UIColor = UIColor(red: 0.0 , green: 1.0, blue: 0.0, alpha: 0.2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //configure cell in this location
        //adding as! customTableviewCell allowed me to access the labels from that class
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! CustomTableViewCell
        //the fetchedobjects grabs the results from the data in
        let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].name
        //which is then displayed in the label
        cell.textName.text = "Task Name: " + (title!)
        
        let notes = self.fetchedResultsController.fetchedObjects?[indexPath.row].notes
        cell.textNotes.text = "Notes: " + (notes!)
        
        let date = self.fetchedResultsController.fetchedObjects?[indexPath.row]
        
        let startDate = self.fetchedResultsController.fetchedObjects?[indexPath.row]
        
        let formatter = DateFormatter()
        
        if let testing = self.fetchedResultsController.fetchedObjects?[indexPath.row].task_progress
        {
            //string interpolation
             cell.testing.text = ("\(testing)" + "%")
            //it animates the progress bar
             cell.circularProgressBar.setProgresswithAnimation(duration: 1.0, value: Float(testing/100))
        }
        //formatting date to string
        formatter.dateFormat = "MM-dd-yyyy"
        cell.textDate?.text = "" + formatter.string(from: (date?.task_dueDate)!)
    
        cell.textStartDate?.text = "" + formatter.string(from: (startDate?.task_date)!)
        
        self.configureCell(cell,indexPath: indexPath)
        
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = cellSelcolour
        
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    // MARK: - Configure this cell
    
    func configureCell (_ cell: UITableViewCell, indexPath: IndexPath)
    {
        cell.backgroundColor = cellcolour
    }
    func  numberOfSections(in tableView: UITableView) -> Int {
        
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = assesment {
            if let label = detailDescriptionLabel {
                label.text = detail.name
            }
        }
    }
    var assesment: Assesment? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
            
        }
        
        let currentAssesment = self.assesment
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        //change this later
        if (self.assesment != nil)
        {
            let predicate = NSPredicate(format: "progressAssesment = %@", currentAssesment!)
            fetchRequest.predicate = predicate
            
        } else {
            
            let predicate = NSPredicate(format: "progressAssesment = %@", "asdas")
            fetchRequest.predicate = predicate
        }
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController<Task>(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: #keyPath(Task.assesment),
            cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            //had to move the code which allows to edit the task
            //the indexpath lets you select the row
            if let indexPath = tableView.indexPathForSelectedRow{
                let object = fetchedResultsController.object(at: indexPath)
                self.currentTask = object
            }
            
            switch identifier
            {
                 //segue name
            case "AssingmentDetail":
                //allows you to access the assesmentdetailviewcontroller class
                let destVC = segue.destination as! AssesmentDetailViewController
                //this fetches all the results on the cell
                if let tasks = fetchedResultsController.fetchedObjects {
                    //variable to calculate the total progress
                    var totalProgress:Double = 0.0
                    //this is to get the number of tasks
                    var numberOfTasks = fetchedResultsController.fetchedObjects?.count ?? 0
                    //it goes through the array and it will call each single task
                    //for-in loop
                    for task in tasks
                    {
                        //adding the totalprogress with every task progress which is stored in the database
                        //it iterates through all the task progress and adds them togther
                        totalProgress = totalProgress + task.task_progress
                    }
                    //divi
                    var progress = totalProgress/Double(numberOfTasks)
                    print("\(progress)")
                    destVC.progress = progress
                    //displays the progress in a label
                    destVC.assesmentProgressLabel = ("\(progress.rounded())" + "%")
                }
                if let name = self.assesment?.name
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.assesmentname = "Module name: " + name
                }
                else
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.assesmentname = "Please Enter Assesment"
                }
                if let notes = self.assesment?.notes
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.textnotes = "Notes: " + notes
                }
                else
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.textnotes = "Please Enter Notes..."
                }
                
                if let value = self.assesment?.value
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.value = ("Value: " + "\(value)")
                }
                else
                {
                    destVC.value = "Please Enter Value..."
                }
                
                if let mark = self.assesment?.mark
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.markAwarded = "Mark Awarded: " + mark
                }
                else
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.markAwarded = "Please Enter Mark awarded..."
                }
                
                if let moduleName = self.assesment?.assignment
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.assesmentName = "Assesment Name: " + moduleName
                }
                else
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.assesmentName = "Please Enter Module Name"
                }
                
                if let dueDate = self.assesment?.date
                {
                    //this access the variable in the assestmentdetailviewcontroller
                    destVC.duedate = dueDate
                }
                else
                {
                    //
                }
            default:
                break
            }
        }
        //this is the segue which i called addTask in the view controller
        if segue.identifier == "addTask"
        {
            let object = self.assesment
            let controller = segue.destination as! AddTaskViewController
            controller.assesment = object

        }
        //this edits the task using the segue name
        if segue.identifier == "EditTask"
        {
            let destVC = segue.destination as! EditTaskViewController
            destVC.currentTask = self.currentTask
        }
    }
    
    //MARK: - table editing
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
        case .move:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

