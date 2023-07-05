//
//  Meal.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/5/23.
//

import UIKit

class Meal: NSObject, Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String

    init(strMeal: String, strMealThumb: String, idMeal: String) {
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.idMeal = idMeal
    }
}
