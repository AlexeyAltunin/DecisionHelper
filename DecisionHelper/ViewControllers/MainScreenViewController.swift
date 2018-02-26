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

        versionLabel.text = NSLocalizedString("liteVersion", value: "Version: Lite 1.0.0", comment: "")
        
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
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        paidVersionAlert()
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        IAPServise.shared.purchase(product: .nonConsumable)
    }
    
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        IAPServise.shared.restorePurchases()
    }
    
    @IBAction func descriptionButtonTapped(_ sender: Any) {
        descriptionAlert()
    }
    
    
    func doAfterPurchase() {
        isPurchased = true
        
        buyButton.isHidden = isPurchased
        restoreButton.isHidden = isPurchased
        versionLabel.text = NSLocalizedString("fullVersion", value: "Version: 1.0", comment: "")
        infoButton.isHidden = isPurchased
    }
    
    @IBAction func paidVersionAlert() {
        let okAction = UIAlertAction(title: NSLocalizedString("continueAlertButton", value: "Next", comment: ""), style: .cancel) {
            (action) in
            // Respond to user selection of the action.
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(
            title: "",
            message: NSLocalizedString("paidVersionAlertDesc", value: "translation", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    @IBAction func descriptionAlert() {
        let closeAction = UIAlertAction(title: NSLocalizedString("closeAlertButton", value: "Close", comment: ""), style: .default) {
            (action) in
        }
        
        let title = NSLocalizedString("descriptionTitleAlert", value: "Description", comment: "")
        let message = NSLocalizedString("descriptionAlert", value: "translation", comment: "")
        
        let mutableData = Alert.getFormatedActionSheetGenerator(title: title, message: message)
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        alert.setValue(mutableData["myMutableTitle"], forKey: "attributedTitle")
        alert.setValue(mutableData["myMutableMessage"], forKey: "attributedMessage")
        
        alert.addAction(closeAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
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

