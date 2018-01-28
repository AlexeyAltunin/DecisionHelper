//
//  ViewController.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 14/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    var isPurchased = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "Версия: Lite 1.0.0"
    /*    versionDescriptionLabel.text = "Lite версия позволяет ввести максимус 3 критерия и 3 альтернативы, что является достаточным количеством для большенства повседневных задач.\n"
        versionDescriptionLabel.text?.append("Если вы хотите увеличть число критериев и альтернатив до 5 или вам просто нравится идея приложения и вы хотите поддержать разработчика, то купите полную версию")
*/
        var options = [
            Option(title: "Альтернатива 1"),
            Option(title: "Альтернатива 2"),
            Option(title: "Альтернатива 3")
        ]
        var criteria = [
            Criteria(title: "Критерий 1", importance: .level4),
            Criteria(title: "Критерий 2", importance: .level4),
            Criteria(title: "Критерий 3", importance: .level1)
        ]
        
        criteria[0].OptionRank = [
            options[0].Title: 3,
            options[1].Title: 2,
            options[2].Title: 1
        ]
        
        criteria[1].OptionRank = [
            options[0].Title: 3,
            options[1].Title: 2,
            options[2].Title: 1
        ]
        
        criteria[2].OptionRank = [
            options[0].Title: 1,
            options[1].Title: 2,
            options[2].Title: 3
        ]
        let sortedDecitions = Decision.getSortedDecisions(options: options, criteria: criteria)
        let bestDecition = sortedDecitions[0]
        print("Лучшая альтернатива: \(bestDecition.Title) количество очков: \(bestDecition.Points)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        paidVersionAlert()
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        isPurchased = true
        
        buyButton.isHidden = isPurchased
        
        if isPurchased {
            versionLabel.text = "Версия: 1.0.0"
        }
        
        infoButton.isHidden = isPurchased
    }
    
    @IBAction func paidVersionAlert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(
            title: "",
            message: "Lite версия позволяет ввести максимум 3 критерия и 3 альтернативы, что является достаточным количеством для большинства повседневных задач.\n\nЕсли вы хотите увеличить число критериев и альтернатив до 5 или вам просто нравится идея приложения и вы хотите поддержать разработчика, то купите полную версию.\nВсе последующие обновления будут выходить для полной версии.",
            preferredStyle: .alert
        )
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let optionsCriterianViewController = navVC.viewControllers.first as! OptionsCriteriaTableViewController
        
        optionsCriterianViewController.isPurchased = self.isPurchased
    }
 
    @IBAction func unwindToMainScreenView(segue: UIStoryboardSegue) {
    }

}

