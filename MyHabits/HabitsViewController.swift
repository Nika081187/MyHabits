//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by v.milchakova on 20.01.2021.
//

import UIKit

let baseOffset: CGFloat = 16.0

class HabitsViewController: UIViewController {
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .none
        button.setImage(#imageLiteral(resourceName: "add_icon"), for: .normal)
        button.addTarget(self, action: #selector(addHabit), for:.touchUpInside)
        return button
    }()
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "Сегодня"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        cv.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .systemGray6
        cv.toAutoLayout()
        return cv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.addSubview(todayLabel)
        todayLabelConstraints()
        
        contentView.addSubview(addButton)
        addButtonConstraints()
        
        contentView.addSubview(habitsCollectionView)
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            habitsCollectionView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 22),
            habitsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func addButtonConstraints() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: baseOffset),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
            addButton.heightAnchor.constraint(equalToConstant: 20),
            addButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func todayLabelConstraints() {
        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            todayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
        ])
    }

    @objc func addHabit() {
        print("Add habit!")
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitsStore().habbitsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let newCell: UICollectionViewCell
        if indexPath.item == 0 {
            let cell: ProgressCollectionViewCell = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell

            cell.configure(procent: 0.5)
            newCell = cell
        } else {
            let habit = HabitsStore().habbitsList[indexPath.item - 1]
            let cell: HabitCollectionViewCell = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
            cell.configure(color: habit.color, name: habit.habitId, time: habit.date, inRow: habit.inRow, isOn: habit.isOn)
            newCell = cell
        }
        return newCell
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - baseOffset*2
        let height = indexPath.item == 0 ? CGFloat(60) : CGFloat(130)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return baseOffset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: baseOffset, left: baseOffset, bottom: baseOffset, right: baseOffset)
    }
}
