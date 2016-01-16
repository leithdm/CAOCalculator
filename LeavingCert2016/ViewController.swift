//
//  ViewController.swift
//  LeavingCert2016
//
//  Created by Darren Leith on 07/01/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var a1: UIButton!
  @IBOutlet weak var a2: UIButton!
  @IBOutlet weak var b1: UIButton!
  @IBOutlet weak var b2: UIButton!
  @IBOutlet weak var b3: UIButton!
  @IBOutlet weak var c1: UIButton!
  @IBOutlet weak var c2: UIButton!
  @IBOutlet weak var c3: UIButton!
  @IBOutlet weak var d1: UIButton!
  @IBOutlet weak var d2: UIButton!
  @IBOutlet weak var d3: UIButton!
  @IBOutlet weak var clearLast: UIButton!
  @IBOutlet weak var clear: UIButton!
  @IBOutlet weak var grade1: UILabel!
  @IBOutlet weak var grade2: UILabel!
  @IBOutlet weak var grade3: UILabel!
  @IBOutlet weak var grade4: UILabel!
  @IBOutlet weak var grade5: UILabel!
  @IBOutlet weak var grade6: UILabel!
  @IBOutlet weak var grade7: UILabel!
  @IBOutlet weak var grade8: UILabel!
  @IBOutlet weak var total: UILabel!
  @IBOutlet weak var paperSegmentControl: UISegmentedControl!
  
  //MARK: - properties
  var gradeButtonArray = [UIButton]()
  var clearButtonArray = [UIButton]()
  var selectPaperButtonArray = [UIButton]()
  var gradeLabels = [UILabel]()
  var ordinary: Bool = false
  var hlMaths: Bool = false
  var honors: Bool = false
  var totalPoints = 0
  var pointsArray = [Int]()
  var paperLevel = ""
  var firstReplacedIndex = -1
  var secondReplacedIndex = -1
  var pointsAchieved = 0
  var topSixColor = UIColor()
  
  //MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    gradeButtonArray = [a1, a2, b1, b2, b3, c1, c2, c3, d1, d2, d3]
    clearButtonArray = [clear, clearLast]
    gradeLabels = [grade1, grade2, grade3, grade4, grade5, grade6, grade7, grade8]
    configureGradeButtons(gradeButtonArray)
    configureClearButtons(clearButtonArray)
    topSixColor = UIColor.init(red: 0/255, green: 170/255, blue: 79/255, alpha: 0.5)

    
  }
  
  //MARK: - configure grade buttons
  func configureGradeButtons(buttons: [UIButton]) {
    for button in buttons {
//      button.layer.cornerRadius = CGRectGetHeight(button.bounds)/4
      button.layer.borderWidth = 1.0
      button.layer.borderColor = UIColor.lightGrayColor().CGColor
//      button.layer.shadowRadius = 0.7
//      button.layer.shadowOpacity = 0.5
//      button.layer.shadowOffset = CGSize.zero
    }
  }
  
  //MARK: - configure clear buttons
  func configureClearButtons(buttons: [UIButton]) {
    for button in buttons {
      button.layer.cornerRadius = 4.0
      button.layer.borderWidth = 0.6
      button.layer.borderColor = UIColor.lightGrayColor().CGColor
//      button.layer.shadowRadius = 0.7
//      button.layer.shadowOpacity = 0.5
//      button.layer.shadowOffset = CGSize.zero
    }
  }
  
  
  //MARK: - Clear Last submitted grade
  @IBAction func clearLast(sender: UIButton) {
//    print("First replaced index \(firstReplacedIndex)")
//    print("Second replaced index \(secondReplacedIndex)")
    
    if !pointsArray.isEmpty {
      if pointsArray.count == 7 {
        if (gradeLabels[pointsArray.count-1].text!.containsString("+25")) {
          paperSegmentControl.setEnabled(true, forSegmentAtIndex: 2)
          paperSegmentControl.selectedSegmentIndex = 0
        }
        gradeLabels[pointsArray.count-1].text = ""
        gradeLabels[pointsArray.count-1].backgroundColor = UIColor.whiteColor()
        pointsArray.removeLast()
        for i in 0..<6 {
          gradeLabels[i].backgroundColor = topSixColor
        }
        calculatePoints()
        setTotalPointsLabel()
        
        //clearing values from Grade 8
      } else if pointsArray.count == 8 {
        
        //case 7th YES, 8th NO
        if firstReplacedIndex != -1 && gradeLabels[6].backgroundColor == topSixColor && gradeLabels[7].backgroundColor == UIColor.whiteColor() {
          totalPoints = totalPoints - pointsArray.last! + pointsArray[firstReplacedIndex]
        }
          //case 7th NO, 8th YES
        else if firstReplacedIndex != -1 && gradeLabels[7].backgroundColor == topSixColor && secondReplacedIndex == -1 {
          totalPoints = totalPoints - pointsArray.last! + pointsArray[firstReplacedIndex]
          gradeLabels[firstReplacedIndex].backgroundColor = topSixColor
          firstReplacedIndex = -1
        }
          //case 7th YES, 8th YES
        else if firstReplacedIndex != -1 && secondReplacedIndex != -1 {
          totalPoints = totalPoints - pointsArray.last! + pointsArray[secondReplacedIndex]
          gradeLabels[secondReplacedIndex].backgroundColor = topSixColor
        }
        
        if (gradeLabels[pointsArray.count-1].text!.containsString("+25")) {
          paperSegmentControl.setEnabled(true, forSegmentAtIndex: 2)
          paperSegmentControl.selectedSegmentIndex = 0
        }
        
        gradeLabels[pointsArray.count-1].text = ""
        gradeLabels[pointsArray.count-1].backgroundColor = UIColor.whiteColor()
        pointsArray.removeLast()
        
        
        //TODO: - not necessary ?
        if pointsArray.count == 0 {
          clearManual()
        }
        setTotalPointsLabel()
      } else {
        if (gradeLabels[pointsArray.count-1].text!.containsString("+25")) {
          paperSegmentControl.setEnabled(true, forSegmentAtIndex: 2)
          paperSegmentControl.selectedSegmentIndex = 0
        }
        gradeLabels[pointsArray.count-1].text = ""
        gradeLabels[pointsArray.count-1].backgroundColor = UIColor.whiteColor()
        pointsArray.removeLast()
        calculatePoints()
        setTotalPointsLabel()
        clearManual()
      }
    }
  }
  
  //MARK: - Clear manually
  func clearManual() {
    firstReplacedIndex = -1
    secondReplacedIndex = -1
    honors = false
    hlMaths = false
    ordinary = false
  }
  
  //MARK: - clear All
  @IBAction func clear(sender: UIButton) {
    for label in gradeLabels {
      label.text = ""
      label.backgroundColor = UIColor.whiteColor()
      paperSegmentControl.setEnabled(true, forSegmentAtIndex: 2)
    }
    honors = false
    hlMaths = false
    ordinary = false
    total.text = "0"
    totalPoints = 0
    pointsArray.removeAll()
    firstReplacedIndex = -1
    secondReplacedIndex = -1
  }
  
  //MARK: - determine selected Segment
  func determinePaperSegment() {
    if paperSegmentControl.selectedSegmentIndex == 0 {
      paperLevel = "(H)"
      honors = true
    }else if paperSegmentControl.selectedSegmentIndex == 1 {
      ordinary = true
      paperLevel = "(O)"
    }else if paperSegmentControl.selectedSegmentIndex == 2 {
      hlMaths = true
      paperLevel = "(+25)"
    }
  }
  
  
  //MARK: - grade selected
  @IBAction func gradeSelected(sender: UIButton) {
    
    determinePaperSegment()
    
    //MARK: - 7 subjects
    if pointsArray.count == 6  {
      if ordinary {
        pointsAchieved = sender.tag - 40
        ordinary = false
      } else if hlMaths {
        pointsAchieved = sender.tag + 25
        paperSegmentControl.setEnabled(false, forSegmentAtIndex: 2)
        paperSegmentControl.selectedSegmentIndex = 0
        hlMaths = false
      } else {
        pointsAchieved = sender.tag
        honors = false
      }
      let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
      gradeLabels[6].text = text
      pointsArray += [pointsAchieved]
      
      let (smallestIndex, smallestValue) = findSmallestValueInPointsArray()
      
      if pointsArray[6] > smallestValue {
        totalPoints = totalPoints - smallestValue + pointsArray[6]
        gradeLabels[6].backgroundColor = topSixColor
        gradeLabels[smallestIndex].backgroundColor = UIColor.whiteColor()
        firstReplacedIndex = smallestIndex
      }
      ordinary = false
    }
      
      //MARK: - 8 subjects
    else if pointsArray.count == 7  {
      if ordinary {
        pointsAchieved = sender.tag - 40
        ordinary = false
      } else if hlMaths {
        pointsAchieved = sender.tag + 25
        paperSegmentControl.setEnabled(false, forSegmentAtIndex: 2)
        paperSegmentControl.selectedSegmentIndex = 0
        hlMaths = false
      } else {
        pointsAchieved = sender.tag
        honors = false
      }
      
      let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
      gradeLabels[7].text = text
      pointsArray += [pointsAchieved]
      
      //the 7th grade did NOT replace anything in the existing 6 set of grades, therefore 8th grade should check for smallest value
      if firstReplacedIndex == -1 {
        let (smallestIndex, smallestValue) = findSmallestValueInPointsArray()
        if pointsArray[7] > smallestValue {
          totalPoints = totalPoints - smallestValue + pointsArray[7]
          gradeLabels[7].backgroundColor = topSixColor
          gradeLabels[smallestIndex].backgroundColor = UIColor.whiteColor()
          firstReplacedIndex = smallestIndex
        }
      }
        //the 7th grade DID replace one of the existing 6 therefore need the lowest grade NOT including the grade already chosen
      else {
        
        let (secondSmallestIndex, secondSmallestValue) = findSecondSmallestValue()
//        print("second smallest value is \(secondSmallestValue)")
        
        if pointsArray[7] > secondSmallestValue {
          totalPoints = totalPoints - secondSmallestValue + pointsArray[7]
          gradeLabels[7].backgroundColor = topSixColor
          gradeLabels[secondSmallestIndex].backgroundColor = UIColor.whiteColor()
          secondReplacedIndex = secondSmallestIndex
        }
      }
    } else if pointsArray.count < 6 {
      if ordinary {
        pointsAchieved = sender.tag - 40
        ordinary = false
      } else if hlMaths {
        pointsAchieved = sender.tag + 25
        paperSegmentControl.setEnabled(false, forSegmentAtIndex: 2)
        paperSegmentControl.selectedSegmentIndex = 0
        hlMaths = false
      } else {
        pointsAchieved = sender.tag
        honors = false
      }
      let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
      gradeLabels[pointsArray.count].text = text
      pointsArray += [pointsAchieved]
      gradeLabels[pointsArray.count-1].backgroundColor = topSixColor
      calculatePoints()
    }
    setTotalPointsLabel()
//    print("First Replaced Index \(firstReplacedIndex)")
//    print("Second Replaced Index \(secondReplacedIndex)")
  }
  
  func findSmallestValueInPointsArray() -> (value: Int, index: Int)  {
    var min = Int.max
    var position = Int.max
    for (index, value) in pointsArray.enumerate() where index != 6 {
      if value < min {
        min = value
        position = index
      }
    }
//    print("smallest position is \(position), smallest value is \(min)")
    return (position, min)
  }
  
  func findSecondSmallestValue() -> (value: Int, index: Int) {
    var min = Int.max
    var position = Int.max
    for (index, value) in pointsArray.enumerate() where index != firstReplacedIndex {
      if value < min  {
        min = value
        position = index
      }
    }
//    print("2nd smallest position is \(position), 2nd smallest value is \(min)")
    return (position, min)
  }
  
  //MARK: - set results label
  func setResultLabel(label: UILabel, sender: UIButton, pointsAchieved: Int) {
    let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
    label.text = text
  }
  
  //MARK: - calculate total points
  func calculatePoints() {
    //    sortedPointsArray = pointsArray.sort(>)
    
    var t = 0
    for i in 0..<pointsArray.count where i < 6 {
      t += pointsArray[i]
    }
    totalPoints = t
//    print("Points Array: \(pointsArray)")
  }
  
  //MARK: - set total points label
  func setTotalPointsLabel() {
    total.text = "\(totalPoints)"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

