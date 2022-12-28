//
//  RecipeTableViewController.swift
//  UChef
//
//  Created by Vicky Liu on 7/19/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import WebKit

class RecipeTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var inventArray: Array<String> = []
    var recipeArray: Array<String> = []
    var linkArray: Array<String> = []
    var link: String = ""
    var userSelectedCell = -1
    var prefCuisine:[String:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInventory()
        displayRecipe()
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
        return recipeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as? RecipeTableViewCell{
            cell.recipeLabel.text = recipeArray[indexPath.row]
            return cell
        }
        print("unable to employ custom cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        userSelectedCell = indexPath.row
        link = linkArray[indexPath.row]
        performSegue(withIdentifier: "cellToWeb", sender: self)
    }
    
    func displayRecipe() {
        db.collection("recipes").getDocuments(){ (querySnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if self.prefCuisine[document.get("cuisine") as! String] == true {
                        var returnRecipe = true
                        var recipeIngredArray: Array<String> = []
                        recipeIngredArray = (document.get("ingredients") as? Array)!
                        for ingred in recipeIngredArray {
                            if !self.inventArray.contains (ingred) {
                                returnRecipe = false
                            }
                        }
                        if returnRecipe {
                            let dishName = (document.documentID)
                            let dishLink = (document.get("link") as! String)
                            self.recipeArray.append(dishName)
                            self.linkArray.append(dishLink)
                        
                            self.tableView.reloadData()
                        }
                    }
                }
            }
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
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? WebViewController {
            destVC.link = link
            print (link)
        }
    }
}
