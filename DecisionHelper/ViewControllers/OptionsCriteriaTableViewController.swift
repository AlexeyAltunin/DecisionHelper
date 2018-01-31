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
            option1TextField.text = "Германия"
            option2TextField.text = "Швейцария"
            criteria1TextField.text = "Природа"
            criteria1SegmentControl.selectedSegmentIndex = 2
            criteria2TextField.text = "Стоимость проживания"
            criteria2SegmentControl.selectedSegmentIndex = 3
            criteria3TextField.text = "Стоимость билетов"
            criteria3SegmentControl.selectedSegmentIndex = 1
            
            self.tableView.isUserInteractionEnabled = !isDemoMode
            
            self.demoDescriptionAlert()
        }
        
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
    
    @IBAction func demoDescriptionAlert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .cancel) {
            (action) in
            self.exampleAlert()
        }
        
        let myString  = "Пример использования"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 18.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:myString.characters.count))
        
        let message = "В бытность мою в С—м уезде мне часто приходилось бывать на Дубовских огородах у огородника Саввы Стукача, или попросту Савки. Эти огороды были моим излюбленным местом для так называемой «генеральной» рыбной ловли, когда, уходя из дому, не знаешь дня и часа, в которые вернешься, забираешь с собой все до одной рыболовные снасти и запасаешься провизией. Собственно говоря, меня не так занимала рыбная ловля, как безмятежное шатанье, еда не вовремя, беседа с Савкой и продолжительные очные ставки с тихими летними ночами. Савка был парень лет 25, рослый, красивый, здоровый, как кремень. Слыл он за человека рассудительного и толкового, был грамотен, водку пил редко, но как работник этот молодой и сильный человек не стоил и гроша медного. Рядом с силой в его крепких, как веревка, мышцах разливалась тяжелая, непобедимая лень. Жил он, как и все на деревне, в собственной избе, пользовался наделом, но не пахал, не сеял и никаким ремеслом не занимался. Старуха мать его побиралась под окнами, и сам он жил, как птица небесная: утром не знал, что будет есть в полдень. Не то, чтобы у него не хватало воли, энергии или жалости к матери, а просто так, не чувствовалось охоты к труду и не сознавалась польза его... От всей фигуры так и веяло безмятежностью, врожденной, почти артистической страстью к житью зря, спустя рукава. Когда же молодое, здоровое тело Савки физиологически потягивало к мышечной работе, то парень ненадолго весь отдавался какой-нибудь свободной, но вздорной профессии вроде точения ни к чему не нужных колышков или беганья с бабами наперегонку. Самым любимым его положением была сосредоточенная неподвижность. Он был в состоянии простаивать целые часы на одном месте, не шевелясь и глядя в одну точку. Двигался же по вдохновению и то только, когда представлялся случай сделать какое-нибудь быстрое, порывистое движение: ухватить бегущую собаку за хвост, сорвать с бабы платок, перескочить широкую яму. Само собою разумеется, что при такой скупости на движения Савка был гол как сокол и жил хуже всякого бобыля. С течением времени должна была накопиться недоимка, и он, здоровый и молодой, был послан миром на стариковское место, в сторожа и пугало общественных огородов. Как ни смеялись над ним по поводу его преждевременной старости, но он и в ус не дул. Это место, тихое, удобное для неподвижного созерцания, было как раз по его натуре."
        
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 18.0)!])
        messageMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkText, range: NSRange(location:0,length:message.characters.count))
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Пример использования",
                                      message: message,
                                      preferredStyle: .actionSheet)
        alert.setValue(myMutableString, forKey: "attributedTitle")
        alert.setValue(messageMutableString, forKey: "attributedMessage")
        
        alert.addAction(okAction)
        
        self.present(alert, animated: false) {
            // The alert was presented
        }
    }
    
    @IBAction func exampleAlert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .cancel) {
            (action) in
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
        let okAction = UIAlertAction(title: "Продолжить", style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Шаг 1",
                                      message: "Описание",
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
