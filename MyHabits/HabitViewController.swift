//
//  HabitViewController.swift
//  MyHabits
//
//  Created by v.milchakova on 24.01.2021.
//

import UIKit

class HabitViewController: UIViewController {
    
    var dateFormatter = DateFormatter()
    var habitDate: Date = Date()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.toAutoLayout()
        return view
    }()

    private lazy var habitNameLabel: UILabel = {
        let label = UILabel()
        label.text = "название".uppercased()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.toAutoLayout()
        return label
    }()
    
    private lazy var habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .black
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 8
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.toAutoLayout()
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "цвет".uppercased()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.toAutoLayout()
        return label
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .green
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(changeColor), for:.touchUpInside)
        return button
    }()
    
    @objc func changeColor() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private lazy var datePickerLabel: UILabel = {
        let label = UILabel()
        label.text = "время".uppercased()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.toAutoLayout()
        return label
    }()
    
    private lazy var everyDayLabel: UILabel = {
        let label = UILabel()
        habitDate = datePicker.date
        label.font = UIFont.systemFont(ofSize: 17)

        let stringValue = "Каждый день в \(dateFormatter.string(from: habitDate))"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColor(color: commonColor, forText: dateFormatter.string(from: habitDate))
        label.attributedText = attributedString

        label.toAutoLayout()
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .time
        date.preferredDatePickerStyle = .wheels
        date.locale = NSLocale(localeIdentifier: "en_US") as Locale
        date.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        date.toAutoLayout()
        return date
    }()
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        habitDate = sender.date
        let stringValue = "Каждый день в \(dateFormatter.string(from: habitDate))"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColor(color: commonColor, forText: dateFormatter.string(from: habitDate))
        everyDayLabel.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dateFormatter.dateFormat = "HH:mm a"
        title = "Создать"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
        
        let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onCancelClicked))
        
        leftBarButtonItem.tintColor = commonColor
        
        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onCreateClicked))
        
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: commonColor],
                for: .normal)
 
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(habitNameLabel)
        contentView.addSubview(habitNameTextField)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorButton)
        contentView.addSubview(datePickerLabel)
        contentView.addSubview(everyDayLabel)
        contentView.addSubview(datePicker)
        
        setupLayout()
        habitNameLabelConstraints()
        habitNameTextFieldConstraints()
        colorLabelConstraints()
        colorButtonConstraints()
        datePickerLabelConstraints()
        everyDayLabelConstraints()
        datePickerConstraints()
    }
    
    @objc func onCancelClicked() {
        print("Нажали Отменить создание привычки!")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onCreateClicked() {
        if habitNameTextField.text != nil && !habitNameTextField.text!.isEmpty {
            let newHabit = Habit(name: habitNameTextField.text!, date: habitDate, color: colorButton.backgroundColor!)
            HabitsStore.shared.habits.append(newHabit)
            HabitsStore.shared.save()
            dismiss(animated: true, completion: nil)
        } else {
             habitNameTextField.layer.borderWidth = 1
             habitNameTextField.layer.borderColor = UIColor.red.cgColor
             habitNameTextField.placeholder = "Имя привычки не заполнено"
        }
        print("Новая привычка создана")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    func habitNameLabelConstraints() {
        NSLayoutConstraint.activate([
            habitNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 22),
            habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            habitNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
        ])
    }
    
    func habitNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            habitNameTextField.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 7),
            habitNameTextField.heightAnchor.constraint(equalToConstant: 30),
            habitNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            habitNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
        ])
    }

    func colorLabelConstraints() {
        NSLayoutConstraint.activate([
            colorLabel.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            colorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
        ])
    }
    
    func colorButtonConstraints() {
        NSLayoutConstraint.activate([
            colorButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorButton.heightAnchor.constraint(equalToConstant: 30),
            colorButton.widthAnchor.constraint(equalToConstant: 30),
            colorButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
        ])
    }
    
    func datePickerLabelConstraints() {
        NSLayoutConstraint.activate([
            datePickerLabel.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 15),
            datePickerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            datePickerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
        ])
    }
    
    func everyDayLabelConstraints() {
        NSLayoutConstraint.activate([
            everyDayLabel.topAnchor.constraint(equalTo: datePickerLabel.bottomAnchor, constant: 7),
            everyDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            everyDayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
        ])
    }
    
    func datePickerConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseOffset),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(baseOffset)),
        ])
    }
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        colorButton.backgroundColor = viewController.selectedColor
    }
}
