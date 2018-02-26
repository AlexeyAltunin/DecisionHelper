//
//  OptionsComparisonTableViewController.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 21/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import UIKit

class OptionsComparisonTableViewController: UITableViewController {

    var options: [Option]?
    var criteria: [Criteria]?
    var separatedOptions = [Int: [Option]]()
    var isDemoMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isEditing = true
        
        for index in 1...self.criteria!.count {
            separatedOptions[index-1] = self.options!
        }
        
        if isDemoMode == true {
            let save = separatedOptions[2]![0]
            separatedOptions[2]![0] = separatedOptions[0]![1]
            separatedOptions[2]![1] = save
            self.tableView.isEditing = !isDemoMode
            
            self.step2Alert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let criteria = self.criteria else {return 0}
        
        return criteria.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let options = self.options else {return 0}
        
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        let placeValue = indexPath.row + 1

        let cuttentTitle = self.separatedOptions[indexPath.section]![indexPath.row].Title
        
        cell.textLabel?.text = cuttentTitle
        
        self.criteria![indexPath.section].OptionRank[cuttentTitle] = Double(self.options!.count - indexPath.row)
        
        if placeValue == 1 {
            cell.detailTextLabel?.text = "🔝 \(NSLocalizedString("place", value: "Place", comment: "")) \(placeValue)"
        } else if placeValue == self.options!.count {
            cell.detailTextLabel?.text = "\(NSLocalizedString("place", value: "Place", comment: "")) \(placeValue)"
        } else {
            cell.detailTextLabel?.text = "\(NSLocalizedString("place", value: "Place", comment: "")) \(placeValue)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(NSLocalizedString("criterion", value: "Сriterion", comment: "")): \(self.criteria![section].Title)"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "\(NSLocalizedString("arrangePlaces", value: "arrange places, 1 - the best alternative", comment: "")), \(self.options!.count) - \(NSLocalizedString("theWorstAlternative", value: "the worst alternative", comment: ""))"
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if fromIndexPath.section == to.section {
            let movedObject = self.separatedOptions[fromIndexPath.section]![fromIndexPath.row]
            self.separatedOptions[fromIndexPath.section]!.remove(at: fromIndexPath.row)
            self.separatedOptions[fromIndexPath.section]!.insert(movedObject, at: to.row)
        }
        self.tableView.reloadData()
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "toResult" {
            let navVC = segue.destination as! UINavigationController
            let resultViewController = navVC.viewControllers.first as! ResultTableViewController
            
            resultViewController.options = options
            resultViewController.criteria = criteria
            resultViewController.isDemoMode = isDemoMode
        }
    }
    
    @IBAction func unwindToOptionsComparisonTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "backUnwind" else { return }
        let resultComparisonViewController = segue.source as! ResultTableViewController
        
        self.options = resultComparisonViewController.options!
        self.criteria = resultComparisonViewController.criteria!
    }
    
    @IBAction func step2Alert() {
        let okAction = UIAlertAction(title: NSLocalizedString("continueAlertButton", value: "Next", comment: ""), style: .default) {
            (action) in
            // Respond to user selection of the action.
        }
        
        let title = NSLocalizedString("step2AlertTitle", value: "Step 2", comment: "")
        let message = NSLocalizedString("step2Alert", value: "translation", comment: "")
        
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
