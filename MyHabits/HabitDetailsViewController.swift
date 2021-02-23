//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by v.milchakova on 23.02.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    var habit: Habit?
    private let table = UITableView(frame: .zero, style: .grouped)
    
    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Этот инит не работает!")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.text = habit!.name
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.toAutoLayout()
        table.backgroundColor = .systemGray6
        table.dataSource = self
        table.delegate = self
        
        view.addSubview(table)
        configureNavigation()
        tableConstraints()
    }
    
    func tableConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = titleLabel

        let rightBarButtonItem = UIBarButtonItem(title: "Править", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onEditClicked))

        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: commonColor],
                for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
   
    @objc func onEditClicked() {
        print("Нажали Править привычку")
        dismiss(animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension HabitDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Активность".uppercased()
    }
}

@available(iOS 13.0, *)
extension HabitDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView()
        header.tintColor = UIColor.systemGray6
        header.textLabel?.textColor = UIColor.gray
        return header
    }
}
