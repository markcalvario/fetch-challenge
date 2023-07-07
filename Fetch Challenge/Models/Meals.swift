//
//  Meals.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/5/23.
//

import UIKit

class Meals: NSObject, Codable {
    let meals: [Meal]

    init(meals: [Meal]) {
        self.meals = meals
    }
}
