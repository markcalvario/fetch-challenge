//
//  MealsViewController.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/5/23.
//

import UIKit

class MealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mealsTV: UITableView!
    
    var meals:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllMeals()
        self.mealsTV.delegate = self
        self.mealsTV.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
        cell.mealName.text = self.meals[indexPath.row].strMeal
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = self.meals[indexPath.row]
        let mealID = meal.idMeal
        print("\(mealID), \(meal)")
        self.performSegue(withIdentifier: "MealVCToMealDetailVC", sender: mealID)
    }
    
    func getAllMeals(){
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        let mySession = URLSession(configuration: config)
        
        let callURL:String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
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
                let mealsData = try JSONDecoder().decode(Meals.self, from: jsonData)
                self.meals = mealsData.meals
                DispatchQueue.main.async {
                    self.mealsTV.reloadData()
                }
                print("Done!")
                
            } catch {
                print("JSON Decode error: \(error)")
            }
        }
        task.resume()
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MealVCToMealDetailVC", let mealID = sender as? String {
            let vc = segue.destination as! MealDetailViewController
            //vc.forumPost = forumPost
            //vc.forumPostID = forumPostID
        }
    }
     */


}
