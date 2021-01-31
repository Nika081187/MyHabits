//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by v.milchakova on 21.01.2021.
//

import UIKit

class HabitsCollectionViewCell: UICollectionViewCell {
    var habitIsOn: Bool = false
    
    private lazy var checkboxImage: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 18
        return image
    }()
    
    private lazy var habiNameLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        return label
    }()
    
    private lazy var habitTimeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var inRowLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    public func configure(color: UIColor, name: String, time: Date, inRow: Int, isOn: Bool){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minutes = calendar.component(.minute, from: time)
        
        self.habitIsOn = HabitsStore().getHabitBy(name: name).isOn
        checkboxImage.backgroundColor = color
        
        if isOn {
            checkboxImage.image = UIImage(systemName: "checkmark.circle")
        } else {
            checkboxImage.image = UIImage(systemName: "checkmark.circle.fill")
        }

        habiNameLabel.text = name
        habiNameLabel.textColor = color
        inRowLabel.text = "Подряд \(inRow)"
        habitTimeLabel.text =  "Каждый день в \(hour):\(minutes)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        addSubview(contentView)
        contentView.addSubview(habiNameLabel)
        contentView.addSubview(habitTimeLabel)
        contentView.addSubview(inRowLabel)
        contentView.addSubview(checkboxImage)
        
        contentViewConstraints()
        habiNameLabelConstraints()
        habitTimeLabelConstraints()
        inRowLabelConstraints()
        checkboxImageConstraints()

        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapCheckboxImage))
        checkboxImage.addGestureRecognizer(tapGestureRecognizer)
        checkboxImage.isUserInteractionEnabled = true
    }
    
    @objc func tapCheckboxImage() {

        if !habitIsOn {
            habitIsOn = true
            checkboxImage.image = UIImage(systemName: "checkmark.circle")

        } else {
            habitIsOn = false
            checkboxImage.image = UIImage(systemName: "checkmark.circle.fill")
        }
        print("Habit Is On: \(habitIsOn)")
    }
    
    func contentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func checkboxImageConstraints() {
        NSLayoutConstraint.activate([
            checkboxImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
            checkboxImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            checkboxImage.heightAnchor.constraint(equalToConstant: 36),
            checkboxImage.widthAnchor.constraint(equalToConstant: 36),
            checkboxImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26)
        ])
    }
    
    func habiNameLabelConstraints() {
        NSLayoutConstraint.activate([
            habiNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            habiNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }
    
    func habitTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            habitTimeLabel.topAnchor.constraint(equalTo: habiNameLabel.bottomAnchor, constant: 4),
            habitTimeLabel.leadingAnchor.constraint(equalTo: habiNameLabel.leadingAnchor)
        ])
    }
    
    func inRowLabelConstraints() {
        NSLayoutConstraint.activate([
            inRowLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            inRowLabel.leadingAnchor.constraint(equalTo: habiNameLabel.leadingAnchor),
        ])
    }
}
