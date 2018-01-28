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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isEditing = true
        
        for index in 1...self.criteria!.count {
            separatedOptions[index-1] = self.options!
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
        //self.options![indexPath.row].Title
        
        self.criteria![indexPath.section].OptionRank[cuttentTitle] = Double(self.options!.count - indexPath.row)
        
        if placeValue == 1 {
            cell.detailTextLabel?.text = "Лучший: место \(placeValue)"
        } else if placeValue == self.options!.count {
            cell.detailTextLabel?.text = "Худший: место \(placeValue)"
        } else {
            cell.detailTextLabel?.text = "место \(placeValue)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Критерий: \(self.criteria![section].Title)"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Расставьте места, где 1 - лучшая альтернатива для критерия, \(self.options!.count) - худшая альтерантива"
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = self.separatedOptions[fromIndexPath.section]![fromIndexPath.row]
        
        self.separatedOptions[fromIndexPath.section]!.remove(at: fromIndexPath.row)
        self.separatedOptions[fromIndexPath.section]!.insert(movedObject, at: to.row)
        self.tableView.reloadData()
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "toResult" {
            let navVC = segue.destination as! UINavigationController
            let resultViewController = navVC.viewControllers.first as! ResultTableViewController
            
            resultViewController.options = options
            resultViewController.criteria = criteria
        }
    }
    
    @IBAction func unwindToOptionsComparisonTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "backUnwind" else { return }
        let resultComparisonViewController = segue.source as! ResultTableViewController
        
        self.options = resultComparisonViewController.options!
        self.criteria = resultComparisonViewController.criteria!
    }
    
    /*
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
     }
    */
 
/*
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
