//
//  EditAssignmentViewController.swift
//  CW2
//
//  Created by amier ali on 13/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
import CoreData
import EventKit
class EditAssignmentViewController: UIViewController {
    
    @IBOutlet weak var textAssignmentName: UITextField!
    
    @IBOutlet weak var textAssignmentNotes: UITextField!
    
    @IBOutlet weak var textValue: UITextField!
    
    @IBOutlet weak var textMarkAwarded: UITextField!
    
    @IBOutlet weak var editDueDate1: UIDatePicker!
    
    @IBOutlet weak var calendarOn: UISwitch!
    
    @IBOutlet weak var assesmentName: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentAssignment:Assesment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //populate the textfields with the data stored
        textAssignmentName.text = currentAssignment?.name
        textAssignmentNotes.text = currentAssignment?.notes
        textValue.text = currentAssignment?.value
        textMarkAwarded.text = currentAssignment?.mark
        assesmentName.text = currentAssignment?.assignment
        editDueDate1.date = currentAssignment?.date! as! Date
    }
    
    @IBAction func UpdateAssesment(_ sender: UIButton) {
        //retrieves the data from each attribute and updates it through the textfields
         let eventStore:EKEventStore = EKEventStore()
        currentAssignment?.name = textAssignmentName.text
        currentAssignment?.notes = textAssignmentNotes.text
        currentAssignment?.mark = textMarkAwarded.text
        currentAssignment?.value = textValue.text
        currentAssignment?.assignment = assesmentName.text
        currentAssignment?.date = editDueDate1.date
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        if self.calendarOn.isOn {
            
            eventStore.requestAccess(to: .event ) {(granted, error) in
                DispatchQueue.main.async {
                    //this code was aquired from tutorial 8
                    if (granted) && (error == nil)
                    {
                        print("granted\(granted)")
                        print("error\(error)")
                        
                        
                        let event:EKEvent = EKEvent(eventStore: eventStore)
                        event.title = self.currentAssignment?.name
                        event.startDate = self.currentAssignment?.date
                        event.endDate = self.currentAssignment?.date
                        event.notes = self.currentAssignment?.notes
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        do{
                            try eventStore.save(event, span: .thisEvent)
                        } catch let error as NSError {
                            print("error : \(error)")
                        }
                        print("save event")
                    }
                    else
                    {
                        print("error : \(error)")
                        
                    }
                }
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
}
