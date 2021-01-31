//
//  HabitsStore.swift
//  MyHabits
//
//  Created by v.milchakova on 20.01.2021.
//

import UIKit

class HabitsStore {
    
    var habbitsList: [Habit]
    static var progressCount = 0
    
    init(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date1 = formatter.date(from: "2020/12/05 22:35")
        let date2 = formatter.date(from: "2021/01/17 20:08")
        let date3 = formatter.date(from: "2021/01/8 12:11")
        
        habbitsList = [
           Habit(habitId: "Habit Name 1", date: date1!, color: .cyan, inRow: 2, isOn: false),
           Habit(habitId: "Habit Name 2", date: date2!, color: .red, inRow: 0, isOn: true),
           Habit(habitId: "Habit Name 3", date: date3!, color: .blue, inRow: 7, isOn: false),
           Habit(habitId: "Habit Name 4", date: date1!, color: .green, inRow: 2, isOn: true),
           Habit(habitId: "Habit Name 5", date: date2!, color: .systemPink, inRow: 0, isOn: true),
           Habit(habitId: "Habit Name 6", date: date3!, color: .systemYellow, inRow: 7, isOn: true),
           Habit(habitId: "Habit Name 7", date: date1!, color: .systemOrange, inRow: 2, isOn: false),
           Habit(habitId: "Habit Name 8", date: date2!, color: .systemTeal, inRow: 0, isOn: true),
           Habit(habitId: "Habit Name 9", date: date3!, color: .systemPurple, inRow: 7, isOn: false)]
        
        for habit in habbitsList {
            if habit.isOn {
//                print(habit.habitId)
                HabitsStore.progressCount = HabitsStore.progressCount + 1
            }
        }
    }
    
    func getHabitBy(name: String) -> Habit {
        
        for habit in habbitsList {
            if habit.habitId == name {
                return habit
            }
        }
        fatalError("Не нашли Habit в хранилище!")
    }
    
    func setHabitStatus(isOn : Bool, for name: String) {
//        getHabitBy(name: name).isOn = isOn
    }
    
//Класс HabitsStore позволяет сохранять и получать сохранённые привычки. Для использования HabitsStore в разных модулях приложения нужно использовать HabitsStore.shared свойство, например:
//
//let store = HabitsStore.shared
//print(store.habits) // распечатает список добавленных привычек
//Привычки, добавленные в HabitsStore, сохраняются между перезапусками приложения автоматически.
}

//Классы Habit и HabitsStore содержат все данные, необходимые для отображения в приложении. Внимательно изучите интерфейсы этих классов и документацию перед работой над проектом.
