//
//  ViewController.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 14/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButtonTapped(_ sender: Any) {
    }
    
    @IBAction func unwindToMainScreenView(segue: UIStoryboardSegue) {
    }

}

