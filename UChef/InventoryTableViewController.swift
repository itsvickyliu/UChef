//
//  InventoryTableViewController.swift
//  UChef
//
//  Created by Vicky Liu on 7/19/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class InventoryTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var inventArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInventory()
        registerTableViewCells()
    }
    
    func registerTableViewCells(){
        let recipeCell = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        self.tableView.register(recipeCell, forCellReuseIdentifier: "recipeCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
      }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as? RecipeTableViewCell{
            cell.recipeLabel.text = inventArray[indexPath.row]
            return cell
        }
        print("unable to employ custom cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let inventRef = self.db.collection("inventory").document("user_name")
            inventRef.updateData(["ingredient": FieldValue.arrayRemove([inventArray[indexPath.row]])])
            inventArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func updateInventory() {
        let inventRef = db.collection("inventory").document("user_name")
        inventRef.getDocument { (document, error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                if let document = document, document.exists {
                    self.inventArray = (document.get("ingredient") as? Array)!
                    self.tableView.reloadData()
                }
            }
        }
    }
    

}
