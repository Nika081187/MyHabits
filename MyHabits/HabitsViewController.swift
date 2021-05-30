//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by v.milchakova on 20.01.2021.
//

import UIKit

class HabitsViewController: UIViewController, UpdateHabitsCollectionViewProtocol {
    
    private enum Constants {
        static let baseOffset: CGFloat = 16.0
    }
    
    func reload() {
        self.habitsCollectionView.reloadData()
        print("Обновляем habits collection view: \(HabitsStore.shared.habits.count)")
        print("Обновляем прогресс: \(HabitsStore.shared.todayProgress)")
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .none
        button.setImage(#imageLiteral(resourceName: "add_icon"), for: .normal)
        button.addTarget(self, action: #selector(addHabitClicked), for:.touchUpInside)
        return button
    }()
    
    private lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HabitsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitsCollectionViewCell.self))
        cv.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
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
        configureNavigation()
        view.addSubview(contentView)
        contentView.addSubview(habitsCollectionView)
        setupLayout()
        
        habitsCollectionView.dataSource = self
        habitsCollectionView.delegate = self
    }
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = "Сегодня"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    func configureNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = todayLabel
        navigationController?.navigationBar.prefersLargeTitles = true

        let rightBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addHabitClicked))
        
        rightBarButtonItem.image = UIImage(systemName: "plus")
        rightBarButtonItem.tintColor = commonColor
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            habitsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            habitsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func addButtonConstraints() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.baseOffset),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(Constants.baseOffset)),
            addButton.heightAnchor.constraint(equalToConstant: 20),
            addButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc func addHabitClicked() {
        print("Нажали кнопку Добавить привычку")
        let navigationController = UINavigationController(rootViewController: HabitViewController())
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Количество привычек: \(HabitsStore.shared.habits.count)")
        return HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Выбрали привычку: \(indexPath.item - 1)")
        if indexPath.item == 0 { return }
        let habit = HabitsStore.shared.habits[indexPath.item - 1]
        let vc = HabitDetailsViewController(habit: habit)
        vc.habitsVc = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let newCell: UICollectionViewCell
        if indexPath.item == 0 {
            guard let cell = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as? ProgressCollectionViewCell else {
                fatalError()
            }
            cell.configure(procent: HabitsStore.shared.todayProgress)
            newCell = cell
        } else if indexPath.item < HabitsStore.shared.habits.count {
            let habit = HabitsStore.shared.habits[indexPath.item - 1]
            guard let cell: HabitsCollectionViewCell = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitsCollectionViewCell.self), for: indexPath) as? HabitsCollectionViewCell else {
                fatalError()
            }
            cell.configure(habit: habit)
            newCell = cell
        } else {
            let habit = HabitsStore.shared.habits[indexPath.item - 1]
            guard let cell = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitsCollectionViewCell.self), for: indexPath) as? HabitsCollectionViewCell else {
                fatalError()
            }
            cell.configure(habit: habit)
            newCell = cell
        }
        return newCell
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - Constants.baseOffset*2
        let height = indexPath.item == 0 ? CGFloat(60) : CGFloat(130)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.baseOffset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Constants.baseOffset, left: Constants.baseOffset, bottom: Constants.baseOffset, right: Constants.baseOffset)
    }
}

extension UIResponder {
    
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}
