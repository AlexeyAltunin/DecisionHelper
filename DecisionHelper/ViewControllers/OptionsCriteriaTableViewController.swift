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
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    var options = [Option]()
    var criteria = [Criteria]()
    
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
                let navVC = segue.destination as! UINavigationController
                let optionsComparisonViewController = navVC.viewControllers.first as! OptionsComparisonTableViewController
                
                optionsComparisonViewController.options = self.options
                optionsComparisonViewController.criteria = self.criteria
            } else {
                self.fieldsShouldBeSetAlert()
            }
        }
    }
    
    @IBAction func fieldsShouldBeSetAlert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Некорректные данные",
            message: "Введите как минимум 2 альтернативы и 2 критерия",
            preferredStyle: .alert)
        alert.addAction(okAction)

        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func unwindToOptionsCriteriaTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "backUnwind" else { return }
        let optionsComparisonViewController = segue.source as! OptionsComparisonTableViewController
        
        self.options = optionsComparisonViewController.options!
        self.criteria = optionsComparisonViewController.criteria!
    }
}
