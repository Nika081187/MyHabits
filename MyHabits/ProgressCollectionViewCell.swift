//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by v.milchakova on 23.01.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.toAutoLayout()
        progress.layer.cornerRadius = 4
        progress.tintColor = commonColor
        return progress
    }()
    
    private lazy var motivationLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .systemGray
        label.text = "Все получится!"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private lazy var procentLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(procent: Float){
        procentLabel.text = "\(Int(HabitsStore.shared.todayProgress*100))%"
        progress.progress = HabitsStore.shared.todayProgress
    }
    
    func setupLayout() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        addSubview(contentView)
        contentView.addSubview(motivationLabel)
        contentView.addSubview(procentLabel)
        contentView.addSubview(progress)
        
        contentViewConstraints()
        motivationLabelConstraints()
        procentLabelConstraints()
        progressConstraints()
    }
    
    func contentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func motivationLabelConstraints() {
        NSLayoutConstraint.activate([
            motivationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        ])
    }
    
    func progressConstraints() {
        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 10),
            progress.leadingAnchor.constraint(equalTo: motivationLabel.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            progress.heightAnchor.constraint(equalToConstant: 7),
            progress.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    func procentLabelConstraints() {
        NSLayoutConstraint.activate([
            procentLabel.topAnchor.constraint(equalTo: motivationLabel.topAnchor),
            procentLabel.trailingAnchor.constraint(equalTo: progress.trailingAnchor),
            procentLabel.bottomAnchor.constraint(equalTo: motivationLabel.bottomAnchor),
        ])
    }
}
