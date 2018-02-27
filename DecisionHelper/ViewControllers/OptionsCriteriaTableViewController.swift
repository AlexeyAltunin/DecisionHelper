//
//  OptionsCriteriaTableViewController.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 16/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import UIKit

class OptionsCriteriaTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var option1TextField: UITextField!
    @IBOutlet weak var option2TextField: UITextField!
    @IBOutlet weak var option3TextField: UITextField!
    @IBOutlet weak var option4TextField: UITextField!
    @IBOutlet weak var option5TextField: UITextField!
    
    @IBOutlet weak var criteria1TextField: UITextField!
    @IBOutlet weak var criteria1SegmentControl: UISegmentedControl!
    @IBOutlet weak var criteria2TextField: UITextField!
    @IBOutlet weak var criteria2SegmentControl: UISegmentedControl!
    @IBOutlet weak var criteria3TextField: UITextField!
    @IBOutlet weak var criteria3SegmentControl: UISegmentedControl!
    @IBOutlet weak var criteria4TextField: UITextField!
    @IBOutlet weak var criteria4SegmentControl: UISegmentedControl!
    @IBOutlet weak var criteria5TextField: UITextField!
    @IBOutlet weak var criteria5SegmentControl: UISegmentedControl!
    
    var isPurchased = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        option1TextField.delegate = self
        option2TextField.delegate = self
        option3TextField.delegate = self
        option4TextField.delegate = self
        option5TextField.delegate = self
        criteria1TextField.delegate = self
        criteria2TextField.delegate = self
        criteria3TextField.delegate = self
        criteria4TextField.delegate = self
        criteria5TextField.delegate = self
        
        if isDemoMode == true {
            self.exampleAlert()
        }
        
        setupViewResizerOnKeyboardShown()
    }
    
    func setExampleData() {
        option1TextField.text = NSLocalizedString("exampleAlternative1", value: "Germany", comment: "")
        option2TextField.text = NSLocalizedString("exampleAlternative2", value: "Switzerland", comment: "")
        criteria1TextField.text = NSLocalizedString("exampleСriterion1", value: "Nature", comment: "")
        criteria1SegmentControl.selectedSegmentIndex = 2
        criteria2TextField.text = NSLocalizedString("exampleСriterion2", value: "Cost of living", comment: "")
        criteria2SegmentControl.selectedSegmentIndex = 3
        criteria3TextField.text = NSLocalizedString("exampleСriterion3", value: "Ticket prices", comment: "")
        criteria3SegmentControl.selectedSegmentIndex = 1
        
        option1TextField.isUserInteractionEnabled = !isDemoMode
        option2TextField.isUserInteractionEnabled = !isDemoMode
        option3TextField.isUserInteractionEnabled = !isDemoMode
        option4TextField.isUserInteractionEnabled = !isDemoMode
        option5TextField.isUserInteractionEnabled = !isDemoMode
        criteria1TextField.isUserInteractionEnabled = !isDemoMode
        criteria2TextField.isUserInteractionEnabled = !isDemoMode
        criteria3TextField.isUserInteractionEnabled = !isDemoMode
        criteria4TextField.isUserInteractionEnabled = !isDemoMode
        criteria5TextField.isUserInteractionEnabled = !isDemoMode
        criteria1SegmentControl.isUserInteractionEnabled = !isDemoMode
        criteria2SegmentControl.isUserInteractionEnabled = !isDemoMode
        criteria3SegmentControl.isUserInteractionEnabled = !isDemoMode
        criteria4SegmentControl.isUserInteractionEnabled = !isDemoMode
        criteria5SegmentControl.isUserInteractionEnabled = !isDemoMode
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    var options = [Option]()
    var criteria = [Criteria]()
    var isDemoMode = false
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isPurchased == false {
            if indexPath.row > 2 {
                return 0
            }
        }
        
        if indexPath.section == 1 {
            return 88
        }
        
        return 44
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        options.removeAll()
        criteria.removeAll()
        
        let optionTitles = [
            option1TextField.text,
            option2TextField.text,
            option3TextField.text,
            option4TextField.text,
            option5TextField.text,
            ]
        
        for optionTitle in optionTitles {
            if optionTitle != "" {
                options.append(Option(title: optionTitle!))
            }
        }
        
        
        let criteriaTitles: [Int: [String: Int]] = [
            1: [criteria1TextField.text!: criteria1SegmentControl.selectedSegmentIndex],
            2: [criteria2TextField.text!: criteria2SegmentControl.selectedSegmentIndex],
            3: [criteria3TextField.text!: criteria3SegmentControl.selectedSegmentIndex],
            4: [criteria4TextField.text!: criteria4SegmentControl.selectedSegmentIndex],
            5: [criteria5TextField.text!: criteria5SegmentControl.selectedSegmentIndex]
        ]
        var importance: Importance?
        
        for critery in criteriaTitles {
            for criteriaTitle in critery.value {
                if criteriaTitle.key != "" {
                    
                    switch criteriaTitle.value {
                    case 0:
                        importance = Importance.level1
                    case 1:
                        importance = Importance.level2
                    case 2:
                        importance = Importance.level3
                    case 3:
                        importance = Importance.level4
                    default: break
                    }
                    
                    criteria.append(Criteria(title: criteriaTitle.key, importance: importance!))
                }
            }
        }
 
        if segue.identifier == "toOprionsComparison" {
            if options.count >= 2 && criteria.count >= 2 {
                let optionTitles = options.map {$0.Title}
                let criteriaTitles = criteria.map {$0.Title}
                
                if areEqualElements(array: optionTitles) || areEqualElements(array: criteriaTitles) {
                    self.fieldsCantBeEqualAlert()
                } else {
                    let navVC = segue.destination as! UINavigationController
                    let optionsComparisonViewController = navVC.viewControllers.first as! OptionsComparisonTableViewController
                    
                    optionsComparisonViewController.options = self.options
                    optionsComparisonViewController.criteria = self.criteria
                    optionsComparisonViewController.isDemoMode = self.isDemoMode
                }
            } else {
                self.fieldsShouldBeSetAlert()
            }
        }
    }
    
    func areEqualElements (array: [String]) -> Bool {
        let setArray = Array(Set(array))
        return setArray.count < array.count
    }
    
    @IBAction func fieldsCantBeEqualAlert() {
        let okAction = UIAlertAction(title: NSLocalizedString("continueAlertButton", value: "Next", comment: ""), style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("incorrectDataTitle", value: "Incorrect data", comment: ""),
                                      message: NSLocalizedString("fieldsCantBeEqualAlert", value: "It can't be the same criteria or alternatives", comment: ""),
                                      preferredStyle: .alert)
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func fieldsShouldBeSetAlert() {
        let okAction = UIAlertAction(title: NSLocalizedString("continueAlertButton", value: "Next", comment: ""), style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }

        // Create and configure the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("incorrectDataTitle", value: "Incorrect data", comment: ""),
            message: NSLocalizedString("fieldsShouldBeSetAlert", value: "Enter at least 2 alternatives and 2 criteria", comment: ""),
            preferredStyle: .alert)
        alert.addAction(okAction)

        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func exampleAlert() {
        let okAction = UIAlertAction(title: NSLocalizedString("continueAlertButton", value: "Next", comment: ""), style: .default) {
            (action) in
            self.setExampleData()
            self.step1Alert()
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: NSLocalizedString("exampleAlertTitle", value: "Example started", comment: ""),
                                      message: NSLocalizedString("exampleAlert", value: "In the example mode, editing fields is not available", comment: ""),
                                      preferredStyle: .alert)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func step1Alert() {
        let okAction = UIAlertAction(title: NSLocalizedString("continueAlertButton", value: "Next", comment: ""), style: .default) {
            (action) in
            // Respond to user selection of the action.
        }
        
        let title = NSLocalizedString("step1AlertTitle", value: "Step 1", comment: "")
        let message = NSLocalizedString(
            "step1Alert",
            value: "Objective: We choose a country for a one-person trip of 3 weeks' duration. The choice was made by two alternatives: 'Germany' or 'Switzerland'. To select the best country we need to indicate the important criteria for us to choose. For example: 'Nature', 'Cost of living' and 'Ticket prices'. Next, we will place the importance under each criterion:\n'1. Nature' = ⭐️⭐️⭐️, this is a rather important indicator for us but not the highest priority.\n'2. Cost of living' = ⭐️⭐️⭐️⭐️, since we are going on a trip for 3 weeks, then the cost of living will be one of the decisive factors\n'3. tickets cost' = ⭐️⭐️, does not depend on the number of days of residence, only one person is flying, so this criterion is less important for us.",
            comment: ""
        )
        
        let mutableData = Alert.getFormatedActionSheetGenerator(title: title, message: message)
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        alert.setValue(mutableData["myMutableTitle"], forKey: "attributedTitle")
        alert.setValue(mutableData["myMutableMessage"], forKey: "attributedMessage")
        
        alert.addAction(okAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true) {
        }
    }
    
    @IBAction func unwindToOptionsCriteriaTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "backUnwind" else { return }
        let optionsComparisonViewController = segue.source as! OptionsComparisonTableViewController
        
        self.options = optionsComparisonViewController.options!
        self.criteria = optionsComparisonViewController.criteria!
    }
    
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing(_:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing(_:)),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    
    @objc func keyboardWillShowForResizing(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }

}
