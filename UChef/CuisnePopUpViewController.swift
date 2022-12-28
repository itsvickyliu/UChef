//
//  CuisnePopUpViewController.swift
//  UChef
//
//  Created by Vicky Liu on 7/22/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import BEMCheckBox

class CuisnePopUpViewController: UIViewController {

    @IBOutlet weak var africanCheck: BEMCheckBox!
    @IBOutlet weak var americanCheck: BEMCheckBox!
    @IBOutlet weak var asianCheck: BEMCheckBox!
    @IBOutlet weak var britishCheck: BEMCheckBox!
    @IBOutlet weak var caribbeanCheck: BEMCheckBox!
    @IBOutlet weak var dutchCheck: BEMCheckBox!
    @IBOutlet weak var europeanCheck: BEMCheckBox!
    @IBOutlet weak var frenchCheck: BEMCheckBox!
    @IBOutlet weak var indianCheck: BEMCheckBox!
    @IBOutlet weak var irishCheck: BEMCheckBox!
    @IBOutlet weak var italianCheck: BEMCheckBox!
    @IBOutlet weak var mediterraneanCheck: BEMCheckBox!
    @IBOutlet weak var mexicanCheck: BEMCheckBox!
    @IBOutlet weak var middleEasternCheck: BEMCheckBox!
    @IBOutlet weak var moroccanCheck: BEMCheckBox!
    @IBOutlet weak var swedishCheck: BEMCheckBox!
    @IBOutlet weak var thaiCheck: BEMCheckBox!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    var prefCuisine:[String:Bool] = ["american": false,"italian":false,"asian":false,"mexican":false,"dutch":false,"indian":false,"british":false,"french":false,"middle-eastern":false,"european":false,"caribbean":false,"irish":false,"mediterranean":false,"moroccan":false,"african":false,"thailand":false,"swedish":false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.titleEdgeInsets.left = 5
        confirmButton.titleEdgeInsets.right = 5

    }
    
    @IBAction func africanChecked(_ sender: Any) {
        prefCuisine["african"] = true
        checkButton(checkBox: africanCheck)
    }
    @IBAction func americanChecked(_ sender: Any) {
        prefCuisine["american"] = true
        checkButton(checkBox: americanCheck)
    }
    @IBAction func asianChecked(_ sender: Any) {
        prefCuisine["asian"] = true
        checkButton(checkBox: asianCheck)
    }
    @IBAction func britishChecked(_ sender: Any) {
        prefCuisine["british"] = true
        checkButton(checkBox: britishCheck)
    }
    @IBAction func caribbeanChecked(_ sender: Any) {
        prefCuisine["caribbean"] = true
        checkButton(checkBox: caribbeanCheck)
    }
    @IBAction func dutchChecked(_ sender: Any) {
        prefCuisine["dutch"] = true
        checkButton(checkBox: dutchCheck)
    }
    @IBAction func europeanChecked(_ sender: Any) {
        prefCuisine["european"] = true
        checkButton(checkBox: europeanCheck)
    }
    @IBAction func frenchChecked(_ sender: Any) {
        prefCuisine["french"] = true
        checkButton(checkBox: frenchCheck)
    }
    @IBAction func indianChecked(_ sender: Any) {
        prefCuisine["indian"] = true
        checkButton(checkBox: indianCheck)
    }
    @IBAction func irishChecked(_ sender: Any) {
        prefCuisine["irish"] = true
        checkButton(checkBox: irishCheck)
    }
    @IBAction func italianChecked(_ sender: Any) {
        prefCuisine["italian"] = true
        checkButton(checkBox: italianCheck)
    }
    @IBAction func mediterraneanChecked(_ sender: Any) {
        prefCuisine["mediterranean"] = true
        checkButton(checkBox: mediterraneanCheck)
    }
    @IBAction func mexicanChecked(_ sender: Any) {
        prefCuisine["mexican"] = true
        checkButton(checkBox: mexicanCheck)
    }
    @IBAction func middleEasternChecked(_ sender: Any) {
        prefCuisine["middle-eastern"] = true
        checkButton(checkBox: middleEasternCheck)
    }
    @IBAction func moroccanChecked(_ sender: Any) {
        prefCuisine["moroccan"] = true
        checkButton(checkBox: moroccanCheck)
    }
    @IBAction func swedishChecked(_ sender: Any) {
        prefCuisine["swedish"] = true
        checkButton(checkBox: swedishCheck)
    }
    @IBAction func thaiChecked(_ sender: Any) {
        prefCuisine["thailand"] = true
        checkButton(checkBox: thaiCheck)
    }    

    @IBAction func confirmed(_ sender: Any) {
        performSegue(withIdentifier: "preferenceToRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? RecipeTableViewController {
            destVC.prefCuisine = prefCuisine
            print (prefCuisine)
        }
    }
    
    func checkButton (checkBox: BEMCheckBox) {
        checkBox.onAnimationType = .fill
        checkBox.offAnimationType = .fill
        checkBox.onTintColor = #colorLiteral(red: 0.9921568627, green: 0.5607843137, blue: 0.3215686275, alpha: 1)
        checkBox.onFillColor = #colorLiteral(red: 0.9921568627, green: 0.5607843137, blue: 0.3215686275, alpha: 1)
        checkBox.tintColor = #colorLiteral(red: 0.9921568627, green: 0.5607843137, blue: 0.3215686275, alpha: 1)
    }
    
}
