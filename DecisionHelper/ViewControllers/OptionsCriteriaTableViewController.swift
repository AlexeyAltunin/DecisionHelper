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
        option1TextField.text = "Германия"
        option2TextField.text = "Швейцария"
        criteria1TextField.text = "Природа"
        criteria1SegmentControl.selectedSegmentIndex = 2
        criteria2TextField.text = "Стоимость проживания"
        criteria2SegmentControl.selectedSegmentIndex = 3
        criteria3TextField.text = "Стоимость билетов"
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
        let okAction = UIAlertAction(title: "Продолжить", style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Некорректные данные",
                                      message: "Не может быть одинаковых критериев или альтернатив",
                                      preferredStyle: .alert)
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
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
    
    @IBAction func exampleAlert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .default) {
            (action) in
            self.setExampleData()
            self.step1Alert()
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Запущен пример",
                                      message: "В режиме примера редактирование полей недоступно",
                                      preferredStyle: .alert)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func step1Alert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .default) {
            (action) in
            // Respond to user selection of the action.
        }
        
        let title = "Шаг 1"
        let message = "Задача: Выбираем страну для путешествия на одного человека продолжительностью 3 недели. Выбор пал на две альтернативы: ‘Германия‘ или ‘Швейцария‘. Для выбора лучшей страны необходимо обозначить важные для нас критерии выбора. Например: ‘Природа‘, ‘Стоимость проживания‘ и ‘Стоимость билетов‘. Далее расставим важность под каждым критерием:\n‘1. Природа‘ = ⭐️⭐️⭐️, это для нас довольно важный показатель но не самый приоритетный.\n‘2. Стоимость проживания‘ = ⭐️⭐️⭐️⭐️, так как мы собираемся в путешествие на 3 недели, то стоимость проживания будет одним из решающих факторов.\n‘3. Стоимость билетов‘ = ⭐️⭐️, не зависит от количества дней проживания, по условию летит всего один человек, поэтому данный критерий для нас маловажен."
        
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
