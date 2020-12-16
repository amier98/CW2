//
//  AddTaskViewController.swift
//  CW2
//
//  Created by amier ali on 15/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
import EventKit
class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var LabelAssesmentName: UILabel!
    
    @IBOutlet weak var addCalendar: UISwitch!
    
    @IBOutlet weak var textTaskName: UITextField!
    
    @IBOutlet weak var textTaskNotes: UITextField!
    
    @IBOutlet weak var testOne: UITextField!
    
    @IBOutlet weak var timeLength: UITextField!
    
    @IBOutlet weak var startDate: UIDatePicker!
    
    @IBOutlet weak var DueDate: UIDatePicker!
    
    var assesment:Assesment?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelAssesmentName.text = self.assesment?.name
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
    
        if (textTaskName.text == "" || textTaskNotes.text == "" || testOne.text == "")
          {
              //alert box to inform the user
              let alert = UIAlertController(title: "Missing Details", message: "Please enter missing details", preferredStyle: .alert)
              let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
              alert.addAction(action)
              self.present(alert, animated: true, completion: nil)
          }
          else
          {
              //this is calling the function which adds the assesment
              addtask()
              let alert = UIAlertController(title: "Added Details", message: "Thank you for entering the task details", preferredStyle: .alert)
              let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
              alert.addAction(action)
              self.present(alert, animated: true, completion: nil)
          }
      }
        
    
    func addtask() {
        
        let eventStore:EKEventStore = EKEventStore()
            //similarily aquiring the attributes from the task entity and
            let task = Task(context: context)
            task.assesment = assesment?.name
            task.task_date = startDate.date
            task.task_dueDate = DueDate.date
            task.name = textTaskName.text
            task.notes = textTaskNotes.text
            task.task_reminder = timeLength.text
            task.task_progress = Double(testOne.text ?? "") ?? 0
            
            assesment?.addToTasks(task)
        //the switch which means if it is on, it will add it to the calendar
        if self.addCalendar.isOn {
            
            eventStore.requestAccess(to: .event ) {(granted, error) in
                
                if (granted) && (error == nil)
                {
                    print("granted\(granted)")
                    print("error\(error)")
                    
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    event.title = task.name
                    event.startDate = task.task_date
                    event.endDate = task.task_dueDate
                    event.notes = task.notes
                    //  event.startDate = task.date
                    
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do{
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("error : \(error)")
                    }
                    print("save event")
                    
                }else{
                    print("error : \(error)")
                }
                
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
      }
    }


    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
   

