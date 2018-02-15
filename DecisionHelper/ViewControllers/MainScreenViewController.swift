//
//  ViewController.swift
//  DecisionHelper
//
//  Created by ALEXEY ALTUNIN on 14/01/2018.
//  Copyright © 2018 ALEXEY ALTUNIN. All rights reserved.
//

import UIKit
import StoreKit

class MainScreenViewController: UIViewController {

    let defaults = UserDefaults.standard
    var isPurchased = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = "Версия: Lite 1.0.0"
        
        IAPServise.shared.getProducts()
        
        print(defaults.bool(forKey: IAPPRoduct.nonConsumable.rawValue))
        if defaults.bool(forKey: IAPPRoduct.nonConsumable.rawValue) {
            doAfterPurchase()
        }
        
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
        IAPServise.shared.purchase(product: .nonConsumable)
    }
    
    func doAfterPurchase() {
        isPurchased = true
        
        buyButton.isHidden = isPurchased
        versionLabel.text = "Версия: 1.0"
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
        
        if segue.identifier == "howItWorksSegue" {
            optionsCriterianViewController.isDemoMode = true
        }
    }
 
    @IBAction func unwindToMainScreenView(segue: UIStoryboardSegue) {
    }

}

