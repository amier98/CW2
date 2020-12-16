//
//  AddAssesmentViewController.swift
//  CW2
//
//  Created by amier ali on 25/04/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
import EventKit

class AddAssesmentViewController: UIViewController {
    
    @IBOutlet weak var textModuleName: UITextField!
    
    @IBOutlet weak var textnotes: UITextField!
    
    @IBOutlet weak var textValue: UITextField!
    
    @IBOutlet weak var TextAssesmentName: UITextField!
    
    @IBOutlet weak var textMark: UITextField!
    
    @IBOutlet weak var DateDue: UIDatePicker!
    
    @IBOutlet weak var addCalendar: UISwitch!
 
    @IBOutlet weak var daysBetween: UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    @IBAction func Save(_ sender: UIButton) {
        //the validation for the texfields
        //it states if they are all empty, fill in the fields.
        if (textModuleName.text == "" || textnotes.text == "" || textValue.text == "" || TextAssesmentName.text == "" || textMark.text == "")
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
            addAssesment()
            let alert = UIAlertController(title: "Added Details", message: "Thank you for entering the details", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func addAssesment() {
        //this is what allows you to access the attributes in the Assesment entity
        let newAssisgnment = Assesment(context: context)
        let eventStore:EKEventStore = EKEventStore()
        newAssisgnment.name = self.textModuleName.text
        newAssisgnment.notes = self.textnotes.text
        newAssisgnment.value = self.textValue.text
        newAssisgnment.mark = self.textMark.text
        newAssisgnment.assignment = self.TextAssesmentName.text
        newAssisgnment.date = self.DateDue.date
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //this is the switch where if it is on, it will save the assesment in the calendar
        if self.addCalendar.isOn  {
            
            eventStore.requestAccess(to: .event ) {(granted, error) in
                DispatchQueue.main.async {
                    //this code was aquired from tutorial 8
                    if (granted) && (error == nil)
                    {
                        print("granted\(granted)")
                        print("error\(error)")
                        
                        
                        let event:EKEvent = EKEvent(eventStore: eventStore)
                        event.title = newAssisgnment.name
                        event.startDate = newAssisgnment.date
                        event.endDate = newAssisgnment.date
                        event.notes = newAssisgnment.notes
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
