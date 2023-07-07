//
//  MealDetailViewController.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/5/23.
//

import UIKit

class MealDetailViewController: UIViewController {
    struct MealDetailsData: Codable {
        let meals: [[String: String?]]
    }

    var mealID:String = ""
    var meal:[String:String?] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getMealDetailWithMealID(self.mealID)
    }
    func showMealDetails() {}

    
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

}
