//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Agnieszka Ilnicka on 24.09.19.
//  Copyright © 2019 Agnieszka Ilnicka. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {

    // MARK: Properties
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use edit button provided by the table view
        navigationItem.leftBarButtonItem = editButtonItem

        //load the saved meals, if there are none, load the sample meals
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data
            loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not the instance of MealTableViewCell.")
        }

        // Fetches the right meal for data source layout
        
        let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
 

  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
       
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
    }

    // MARK: Actions
    @IBAction func unwindToMealList(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal
                let newIndexPath = IndexPath(row:meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            //save the meals
            saveMeals()
        }
    }
    
    // MARK: Private Methods
    private func loadSampleMeals() {
        // load 3 images of meals
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        // make sample meals
        guard let meal1 = Meal(name: "Wegeburger", photo: photo1, rating: 5) else {
            fatalError("Problem with meal1")
        }
        guard let meal2 = Meal(name: "Dynioki (Dyniowe gnocchi)", photo: photo2, rating: 5) else {
            fatalError("Problem with meal2")
        }
        guard let meal3 = Meal(name: "Liofilizowane puree z kukurydza ", photo: photo3, rating: 5) else {
            fatalError("Problem with meal3")
        }
        
        meals += [meal1, meal2, meal3]
    }
 
    private func saveMeals() {

        /*
         let isSuccessfulSaved = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
         if isSuccessfulSaved {
         os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
         } else {
         os_log("Failed to save meals...", log: OSLog.default, type: .error)
         }
         */
        
        do {
            try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false).write(to: Meal.ArchiveURL)
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        

    }
    
    private func loadMeals()->[Meal]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
        do {
            let DataFromFile = try Data(contentsOf: Meal.ArchiveURL)
            
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(DataFromFile) as? [Meal]
        } catch {
            os_log("Failed to load meals...", log: OSLog.default, type: .error)
            return nil
        }
        
        
    }
    
}
