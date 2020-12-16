//
//  EditTaskViewController.swift
//  CW2
//
//  Created by amier ali on 18/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
import EventKit
import CoreData
class EditTaskViewController: UIViewController {

    @IBOutlet weak var textTaskName: UITextField!
    
    @IBOutlet weak var textTaskNotes: UITextField!
    
    @IBOutlet weak var taskComplete: UITextField!
    
    @IBOutlet weak var addCalendar: UISwitch!
    
    var progress = 0.0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentTask:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textTaskName.text = currentTask?.name
        //this is to populate the texfields with the data stored
        textTaskNotes.text = currentTask?.notes
        let progress = currentTask?.task_progress ?? 0
        let stringProgress = String(progress)
        taskComplete.text = stringProgress
        
    }
    
    @IBAction func Update(_ sender: UIButton) {
        //these gets the attribute in the task enity
        //which is then put into the labels
        currentTask?.name = textTaskName.text
        currentTask?.notes = textTaskNotes.text
        currentTask?.task_progress = Double(taskComplete.text ?? "") ?? 0
         let eventStore:EKEventStore = EKEventStore()
        
        
        if self.addCalendar.isOn {
            
            eventStore.requestAccess(to: .event ) {(granted, error) in
                
                if (granted) && (error == nil)
                {
                    print("granted\(granted)")
                    print("error\(error)")
                    
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    event.title = self.currentTask?.name
                    event.startDate = self.currentTask?.task_date
                    event.endDate = self.currentTask?.task_dueDate
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
