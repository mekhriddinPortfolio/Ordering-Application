
//
//  RegisterViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 06/07/22.
//

import UIKit

class RegController: BaseViewController {
    
    var isMaleChosen = true
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Зарегестрируйтесь для того чтобы начать заказывать и искать свои любимые продукты прямо сейчас с Oq-ot"
        label.font = UIFont.systemFont(ofSize: 11 * RatioCoeff.height)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#F7F8F9")
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var textField1 = CustomTextField(placeholder: "Ваше имя", textAlignment: .left)
    lazy var textField2 = CustomTextField(placeholder: "Ваша фамилия", textAlignment: .left)
    lazy var textField3 = CustomTextField(placeholder: "Выберите дату", textAlignment: .left)
    
    
    lazy var grayLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Имя"
        return label
    }()
    
    lazy var grayLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Фамилия"
        return label
    }()
    
    lazy var grayLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Дата рождения"
        return label
    }()
    
    lazy var calendarButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.setImage(UIImage.init(named: "calendarIcon"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(calendarTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var chooseGenderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#F7F8F9")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(hex: "#E8ECF4").cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var chooseMaleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#F7F8F9")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(hex: "#DE8706").cgColor
        view.layer.cornerRadius = 8
        let tap = UITapGestureRecognizer(target: self, action: #selector(maleTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var chooseFemaleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "#F7F8F9")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(femaleTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var genderLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Мужской"
        return label
    }()
    
    lazy var genderLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.text = "Женский"
        return label
    }()
    
    lazy var grayLabel4: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10 * RatioCoeff.height)
        label.textColor = .black
        label.text = "Пол"
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10 * RatioCoeff.height)
        label.textColor = UIColor.init(hex: "#D82F3C")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    
    let saveButton = CustomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        
        saveButton.setTitle("Сохранить", for: .normal)
        
        giveConstraints()
        configureGenderView()
        
        
        textField3.rightViewMode = .always
        textField3.rightView = paddingRightIcon(calendarButton, 5)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        
        slideUpView.delegate = self
    }
    
    @objc private func viewPressed() {
        view.endEditing(true)
    }
   
    private func paddingRightIcon(_ view: UIView, _ padding: CGFloat) -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.addSubview(view)
        contentView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 50 + padding, height: 50))
        view.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        return contentView
    }
    

    
    
    @objc func calendarTapped() {
        present(slideUpView, animated: true)
    }
    
    @objc func maleTapped() {
        chooseMaleView.layer.borderColor = UIColor.init(hex: "#DE8706").cgColor
        chooseFemaleView.layer.borderColor = UIColor.clear.cgColor
        genderLabel1.textColor = .black
        genderLabel2.textColor = .systemGray
        isMaleChosen = true
        // male
    }
    
    @objc func femaleTapped() {
        chooseFemaleView.layer.borderColor = UIColor.init(hex: "#DE8706").cgColor
        chooseMaleView.layer.borderColor = UIColor.clear.cgColor
        genderLabel1.textColor = .systemGray
        genderLabel2.textColor = .black
        isMaleChosen = false
        // female
    }
    
    @objc func saveTapped() {
        
        for textField in [textField1, textField2, textField3] {
            if textField.text?.trimmingCharacters(in: .whitespaces) == "" {
                errorLabel.text = "* Для того чтобы продолжить, пожалуйста заполните все поля"
                textField.layer.borderColor = UIColor.init(hex: "#D82F3C").cgColor
                return
            } else {
                errorLabel.text = ""
                textField.layer.borderColor = UIColor.init(hex: "#E8ECF4").cgColor
            }
        }
        
        
        // Сохранить
    }
    
    private func giveConstraints() {
        view.addSubview(bodyView)
        bodyView.addSubview(bodyLabel)
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
        view.addSubview(grayLabel1)
        view.addSubview(grayLabel2)
        view.addSubview(grayLabel3)
        view.addSubview(saveButton)
        
        bodyView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 70 * RatioCoeff.height , left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56 * RatioCoeff.height))
        
        bodyLabel.anchor(top: bodyView.topAnchor, leading: bodyView.leadingAnchor, bottom: bodyView.bottomAnchor, trailing: bodyView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        bodyLabel.centerYAnchor.constraint(equalTo: bodyView.centerYAnchor).isActive = true
        
        textField1.anchor(top: bodyLabel.bottomAnchor, leading: bodyLabel.leadingAnchor, bottom: nil, trailing: bodyLabel.trailingAnchor, padding: UIEdgeInsets(top: 33 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        textField2.anchor(top: textField1.bottomAnchor, leading: textField1.leadingAnchor, bottom: nil, trailing: textField1.trailingAnchor, padding: UIEdgeInsets(top: 33 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        textField3.anchor(top: textField2.bottomAnchor, leading: textField2.leadingAnchor, bottom: nil, trailing: textField2.trailingAnchor, padding: UIEdgeInsets(top: 33 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        
        
        grayLabel1.anchor(top: nil, leading: textField1.leadingAnchor, bottom: textField1.topAnchor, trailing: textField1.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        grayLabel2.anchor(top: nil, leading: textField2.leadingAnchor, bottom: textField2.topAnchor, trailing: textField2.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        grayLabel3.anchor(top: nil, leading: textField3.leadingAnchor, bottom: textField3.topAnchor, trailing: textField3.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        
        saveButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 32 * RatioCoeff.height, right: 16), size: CGSize(width: 154 * 0, height: 45 *  RatioCoeff.height))
        
    }
    
    private func configureGenderView() {
        view.addSubview(chooseGenderView)
        view.addSubview(grayLabel4)
        chooseGenderView.addSubview(chooseMaleView)
        chooseGenderView.addSubview(chooseFemaleView)
        chooseMaleView.addSubview(genderLabel1)
        chooseFemaleView.addSubview(genderLabel2)
        view.addSubview(errorLabel)
        
        chooseGenderView.anchor(top: textField3.bottomAnchor, leading: textField3.leadingAnchor, bottom: nil, trailing: textField3.trailingAnchor, padding: UIEdgeInsets(top: 36 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 45 * RatioCoeff.height))
        grayLabel4.anchor(top: nil, leading: chooseGenderView.leadingAnchor, bottom: chooseGenderView.topAnchor, trailing: chooseGenderView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: 18))
        chooseMaleView.anchor(top: chooseGenderView.topAnchor, leading: chooseGenderView.leadingAnchor, bottom: chooseGenderView.bottomAnchor, trailing: chooseGenderView.centerXAnchor, padding: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        chooseFemaleView.anchor(top: chooseGenderView.topAnchor, leading: chooseGenderView.centerXAnchor, bottom: chooseGenderView.bottomAnchor, trailing: chooseGenderView.trailingAnchor, padding: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        genderLabel1.anchor(top: chooseMaleView.topAnchor, leading: chooseMaleView.leadingAnchor, bottom: chooseMaleView.bottomAnchor, trailing: chooseMaleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        genderLabel2.anchor(top: chooseFemaleView.topAnchor, leading: chooseFemaleView.leadingAnchor, bottom: chooseFemaleView.bottomAnchor, trailing: chooseFemaleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        errorLabel.anchor(top: chooseGenderView.bottomAnchor, leading: chooseGenderView.leadingAnchor, bottom: nil, trailing: chooseGenderView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 30 * RatioCoeff.height))
    }
    
    lazy var slideUpView = CalendarViewController()
    
    let slideUpViewHeight: CGFloat = UIScreen.main.bounds.size.height / 2
    let screenSize = UIScreen.main.bounds.size
    
}


extension RegController: CalendarViewDelegate {
    func didTapCalendar(selectedDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textField3.text = formatter.string(from: selectedDate)
        dismiss(animated: true)
    }
}
