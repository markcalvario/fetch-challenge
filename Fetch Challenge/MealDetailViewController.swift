//
//  MealDetailViewController.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/5/23.
//

import UIKit

class MealDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct MealDetailsData: Codable {
        let meals: [[String: String?]]
    }

    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var ingredientsTV: UITableView!
    var mealID:String = ""
    var meal:[String:String?] = [:]
    var ingredients:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ingredientsTV.dataSource = self
        self.ingredientsTV.delegate = self
        
        self.getMealDetailWithMealID(self.mealID)
    }
    
    
    func showMealDetails() {
        self.ingredientsTV.reloadData()
        let instructions = self.meal["strInstructions"] as? String
        let mealName = self.meal["strMeal"] as? String
        if instructions != nil {
            self.instructionsLabel.text = instructions
        }
        if mealName != nil {
            self.mealNameLabel.text = mealName
        }
    }

    func getMealDetailWithMealID(_ id:String){
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        let mySession = URLSession(configuration: config)
        
        let callURL:String = "https://themealdb.com/api/json/v1/1/lookup.php?i="+id
        let url = URL(string: callURL)!
        let task = mySession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error - ", message: "No network connection.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            guard let jsonData = data else {
                print("No data")
                return
            }
            do {
                let mealsDetailsData = try JSONDecoder().decode(MealDetailsData.self, from: jsonData)
                self.meal = mealsDetailsData.meals[0]
                
                for i in 1...20 {
                    let ingredientKey = "strIngredient" + String(i)
                    let measurementKey = "strMeasure" + String(i)
                    
                    let ingredient = self.meal[ingredientKey] as? String
                    let measurement = self.meal[measurementKey] as? String
                    
                    if (ingredient != nil && measurement != nil) {
                        let measuredIngredient = measurement! + " " + ingredient!
                        if (!measuredIngredient.trimmingCharacters(in: .whitespaces).isEmpty) {
                            self.ingredients.append(measuredIngredient)
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.showMealDetails()
                }
                print("Done!")
                
            } catch {
                print("JSON Decode error: \(error)")
            }
        }
        task.resume()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.ingredientLabel.text = self.ingredients[indexPath.row]
        return cell
    }
}
