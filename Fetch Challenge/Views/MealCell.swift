//
//  MealCell.swift
//  Fetch Challenge
//
//  Created by Mark Calvario on 7/7/23.
//

import UIKit

class MealCell: UICollectionViewCell {
    
    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var mealImgView: UIImageView!
    
    let bgColorView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellUIWithMeal(_ meal:Meal) {
        
        self.mealNameLabel.text = meal.strMeal
        self.mealImgView.bringSubviewToFront(self.mealNameLabel)
        self.mealImgView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.bgColorView.backgroundColor = UIColor(white: 0, alpha: 0.35)
        self.bgColorView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.mealImgView.addSubview(self.bgColorView)
    }
}
