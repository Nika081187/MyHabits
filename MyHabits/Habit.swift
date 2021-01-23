//
//  Habit.swift
//  MyHabits
//
//  Created by v.milchakova on 21.01.2021.
//

import UIKit

class Habit {
    let habitId: String
    let date: Date
    let color: UIColor
    let inRow: Int
    let isOn: Bool
    
    init(habitId: String, date: Date, color: UIColor, inRow: Int, isOn: Bool) {
        self.habitId = habitId
        self.date = date
        self.color = color
        self.inRow = inRow
        self.isOn = isOn
    }
}
