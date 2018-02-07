//
//  resultTableViewController.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 24/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {

    var options: [Option]?
    var criteria: [Criteria]?
    var isDemoMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.options = Decision.getSortedDecisions(options: self.options!, criteria: self.criteria!)
        let bestDecition = self.options![0]
        print("Лучшая альтернатива: \(bestDecition.Title) количество очков: \(bestDecition.Points)")
        
        if isDemoMode == true {
            self.step3Alert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let options = self.options else {return 0}
        
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)

        if self.options![indexPath.row].Points == self.options![0].Points {
            cell.contentView.backgroundColor = UIColor.lightText
        }
        
        cell.textLabel?.text = self.options![indexPath.row].Title
        cell.detailTextLabel?.text = "Очков: \(self.options![indexPath.row].Points)"
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Лучшая альтернатива"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var criteriaLine = "Критерии: "
        
        self.criteria!.forEach { critery in
            criteriaLine += "\(critery.Title), "
        }
        
        return criteriaLine.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
    }
    
    @IBAction func step3Alert() {
        let okAction = UIAlertAction(title: "Продолжить", style: .default) {
            (action) in
            // Respond to user selection of the action.
        }
        
        let title = "Результат"
        let message = "На основании введенных данных алгоритм вычисляет итоговое количество очков. Альтернатива с наибольшим количеством очков является лучшей. В данном случаи разница между Германией и Швейцарией несильно большая, однако именно для вас лучше будет поехать в Германию. В этом и заключается особенность метода: вычисления были сделаны в соответсвии с вашими потребностями, условиями задачи и основываясь на вашем мнении."
        
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
            // The alert was presented
        }
    }
}
