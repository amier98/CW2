//
//  AssesmentDetailViewController.swift
//  CW2
//
//  Created by amier ali on 12/05/2020.
//  Copyright © 2020 amier ali. All rights reserved.
//

import UIKit
import CoreData
class AssesmentDetailViewController: UIViewController {
    
    @IBOutlet weak var showDaysLeft: UILabel!
    
    @IBOutlet weak var assesmentCircularBar: cuustomView!
    
    @IBOutlet weak var daysUntilCircularProgressBar: cuustomView!
    
    @IBOutlet weak var daysUntilCircularBar: UIView!
    
    @IBOutlet weak var ModuleName: UILabel!
    //@IBOutlet weak var AssesmentName: UILabel!
    //these are all outlets for the text views
    @IBOutlet weak var TextViewAssesmentNotes: UITextView!
    //these are all outlets for the text views
    @IBOutlet weak var textViewValue: UITextView!
    //these are all outlets for the text views
    @IBOutlet weak var textViewMarkAwarded: UITextView!
    //this is the outlet for displaying the date
    @IBOutlet weak var DueDate: UILabel!
    
    @IBOutlet weak var textViewAssesmentName: UITextView!
    
    
    @IBOutlet weak var daysUntil: UILabel!
    
    //@IBOutlet weak var daysUntil: UILabel!
    
    @IBOutlet weak var assementProgress: UILabel!
    //these are the variables which are used to get the data from the detailviewcontroller
    var progress:Double = 0.0
    var assesmentProgressLabel = ""
    var textnotes = ""
    var assesmentname = ""
    var markAwarded = ""
    var value = ""
    var assesmentName = ""
    var duedate = Date()
    var currentDate = Date()
    var formatter = DateFormatter()
    var assesment:Assesment?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        ModuleName.text = assesmentname
        TextViewAssesmentNotes.text = textnotes
        textViewValue.text = value
        textViewMarkAwarded.text = markAwarded
        textViewAssesmentName.text = assesmentName
        assementProgress.text = assesmentProgressLabel
        //formatting the string
        formatter.dateFormat = "MMM d yyyy, h:mm"
        let formattedDateinString = formatter.string(from: duedate)
        DueDate.text = formattedDateinString
        assesmentCircularBar.setProgresswithAnimation(duration: 1.0, value: Float(progress)/100)
        let days = daysLeft(date1: Date(), date2: duedate)
        let days2 = daysPercent(date1: Date(), date2: duedate)
        daysUntilCircularProgressBar.setProgresswithAnimation(duration: 1, value: Float(days)/100)
        daysUntil.text = ("\(days2) " + "days left")
    
    }
    //this is the calculation which was given by phil in the solution
    //had to adapt it slightly
    func daysLeft(date1:Date, date2:Date) ->Int
      {
          //this is seconds
          let secs = self.duedate.timeIntervalSince(self.currentDate)
          //to days
          let days = secs/(60*60*24) + 1
          let days2 = 100/days
          return Int(days2)
      }
    func daysPercent(date1:Date, date2:Date) ->Int
    {
        //this is the same function, to display the number of days left in the label
        let secs = self.duedate.timeIntervalSince(self.currentDate)
       //to days
        let days = (secs/(60*60*24)) + 1
        return Int(days)
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

