//
//  MealsViewController.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/5/23.
//

import UIKit

class MealsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mealCV: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    var meals:[Meal] = []
    var filteredMeals:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealCV.delegate = self
        self.mealCV.dataSource = self
        self.searchBar.delegate = self
        self.getAllMeals()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! MealCell
        let meal = self.filteredMeals[indexPath.row]
        let mealPicURL = meal.strMealThumb
        self.getImage(mealPicURL, mealCVCell: cell)
        cell.setCellUIWithMeal(meal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset.left = 10
        flowLayout.sectionInset.right = 10
        
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 2
        
        let dimensions = CGFloat(Int(totalwidth - flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / numberOfCellsPerRow)
        return CGSizeMake(dimensions, dimensions)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = self.filteredMeals[indexPath.row]
        let mealID = meal.idMeal
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
                self.filteredMeals = self.meals
                DispatchQueue.main.async {
                    self.mealCV.reloadData()
                }
                print("Done!")
            } catch {
                print("JSON Decode error: \(error)")
            }
        }
        task.resume()
        
    }
    
    func getImage(_ mealPicURL:String, mealCVCell:MealCell){
        let theURL = URL(string: mealPicURL)
        if let url = theURL {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Network Error - ", message: "No network connection.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    return
                }
                
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    mealCVCell.mealImgView.image = UIImage(data: imageData)
                }
                
            }.resume()
        }
    }
    
    // MARK: UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased()
        if (text.count == 0) {
            self.toggleSearchBar()
        } else {
            var matchingMeals = [Meal]()
            for meal in self.meals {
                let mealName = meal.strMeal.lowercased()
                if mealName.contains(text) {
                    matchingMeals.append(meal)
                }
            }
            self.filteredMeals = matchingMeals
            self.mealCV.reloadData()
        
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.toggleSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.toggleSearchBar()
    }
    
    func toggleSearchBar() {
        self.filteredMeals = self.meals
        self.mealCV.reloadData()
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.view.endEditing(true)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealVCToMealDetailVC", let mealID = sender as? String {
            let vc = segue.destination as! MealDetailViewController
            vc.mealID = mealID
        }
    }
}
