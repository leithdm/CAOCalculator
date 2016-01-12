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
  @IBOutlet weak var grade9: UILabel!
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
  var sortedPointsArray = [Int]()
  var paperLevel = ""
  var tempDict = [Int: Int]()
  var topSix = [Int]()
  var tempArray = [Int]()
  
  //MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    gradeButtonArray = [a1, a2, b1, b2, b3, c1, c2, c3, d1, d2, d3]
    clearButtonArray = [clear, clearLast]
    gradeLabels = [grade1, grade2, grade3, grade4, grade5, grade6, grade7, grade8, grade9]
    configureGradeButtons(gradeButtonArray)
    configureClearButtons(clearButtonArray)
    
  }
  
  //MARK: - configure the grade buttons
  func configureGradeButtons(buttons: [UIButton]) {
    for button in buttons {
      button.layer.cornerRadius = CGRectGetHeight(button.bounds)/4
      button.layer.borderWidth = 0.1
      button.layer.borderColor = UIColor.darkGrayColor().CGColor
      button.layer.shadowRadius = 0.7
      button.layer.shadowOpacity = 0.5
      button.layer.shadowOffset = CGSize.zero
    }
  }
  
  //MARK: - configure the clear buttons
  func configureClearButtons(buttons: [UIButton]) {
    for button in buttons {
      button.layer.cornerRadius = 8.0
      button.layer.borderWidth = 0.05
      button.layer.borderColor = UIColor.darkGrayColor().CGColor
      button.layer.shadowRadius = 0.7
      button.layer.shadowOpacity = 0.5
      button.layer.shadowOffset = CGSize.zero
    }
  }
  
  
  //MARK: - clear Last submitted grade
  @IBAction func clearLast(sender: UIButton) {
    if !pointsArray.isEmpty {
      if (gradeLabels[pointsArray.count-1].text!.containsString("+25")) {
        paperSegmentControl.setEnabled(true, forSegmentAtIndex: 2)
        paperSegmentControl.selectedSegmentIndex = 0
      }
      gradeLabels[pointsArray.count-1].text = ""
      gradeLabels[pointsArray.count-1].backgroundColor = UIColor.whiteColor()
      pointsArray.removeLast()
        print(pointsArray)
      calculatePoints()
      setTotalPointsLabel()
    }
  }
  
  //MARK: - clear All
  @IBAction func clear(sender: UIButton) {
    for label in gradeLabels {
      label.text = ""
      paperSegmentControl.setEnabled(true, forSegmentAtIndex: 2)
    }
    total.text = "Total: 0 Points"
    totalPoints = 0
    pointsArray.removeAll()
    sortedPointsArray.removeAll()
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
  
  func sortFunc(num1: Int, num2: Int) -> Bool {
    return num1 < num2
  }
  
  
  
  //MARK: - grade selected
  @IBAction func gradeSelected(sender: UIButton) {
    
    determinePaperSegment()
    
    if pointsArray.count > 5 && pointsArray.count < 9  {
      if ordinary {
        tempArray = pointsArray
        let pointsAchieved = sender.tag - 40
        let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
        gradeLabels[pointsArray.count].text = text
        pointsArray += [pointsAchieved]
        print(pointsArray)
        setColor()
        ordinary = false
      }else if hlMaths {
        let pointsAchieved = sender.tag + 25
        let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
        gradeLabels[pointsArray.count].text = text
        pointsArray += [pointsAchieved]
        print(pointsArray)
        paperSegmentControl.setEnabled(false, forSegmentAtIndex: 2)
        paperSegmentControl.selectedSegmentIndex = 0
                setColor()
        hlMaths = false
      } else {
        let pointsAchieved = sender.tag
        let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
        gradeLabels[pointsArray.count].text = text
        pointsArray += [pointsAchieved]
        print(pointsArray)
        setColor()
        honors = false
      }
    } else if pointsArray.count < 9 {
      if ordinary {
        let pointsAchieved = sender.tag - 40
        let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
        gradeLabels[pointsArray.count].text = text
        pointsArray += [pointsAchieved]
        print(pointsArray)
        ordinary = false
      } else if hlMaths {
        let pointsAchieved = sender.tag + 25
        let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
        gradeLabels[pointsArray.count].text = text
        pointsArray += [pointsAchieved]
        print(pointsArray)
        paperSegmentControl.setEnabled(false, forSegmentAtIndex: 2)
        paperSegmentControl.selectedSegmentIndex = 0
        hlMaths = false
      } else {
        let pointsAchieved = sender.tag
        let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
        gradeLabels[pointsArray.count].text = text
        pointsArray += [pointsAchieved]
        print(pointsArray)
        honors = false
      }
      gradeLabels[pointsArray.count-1].backgroundColor = UIColor.yellowColor()
    }
    calculatePoints()
    setTotalPointsLabel()
  }
  
  
  //MARK: - set the results label
  func setResultLabel(label: UILabel, sender: UIButton, pointsAchieved: Int) {
    let text = "\(sender.titleLabel!.text!)\(paperLevel)  \(pointsAchieved)"
    label.text = text
  }
  
  //MARK: - calculate total points
  func calculatePoints() {
    

    sortedPointsArray = pointsArray.sort(>)
    
    var t = 0
    for i in 0..<sortedPointsArray.count where i < 6 {
      t += sortedPointsArray[i]
    }
    totalPoints = t
    print("Sorted Points Array: \(sortedPointsArray)")
  }
  
  //MARK: - set the total points label
  func setTotalPointsLabel() {
    total.text = "Total: \(totalPoints) points"
    
  }
  
  //MARK: - TODO
  func setColor() {
    for i in 0..<9 {
      gradeLabels[i].backgroundColor = UIColor.whiteColor()
    }
    for (index, value) in pointsArray.enumerate() {
      for i in 0..<sortedPointsArray.count where i < 6 {
        if pointsArray[index] > sortedPointsArray[i] {
          print("\(pointsArray[index]) is in the top six")
          gradeLabels[index].backgroundColor = UIColor.yellowColor()
          break
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

