//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Mekhriddin on 08/07/22.
//

protocol CalendarViewDelegate: AnyObject {
    func didTapCalendar(selectedDate: Date)
}

import UIKit

class CalendarViewController: UIViewController {
    
    var selectedIndex: Int?
    var selectedMonth: String?
    var selectedYear: String?
    
    weak var delegate: CalendarViewDelegate?
    
    lazy var calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Июнь"
        label.font = UIFont.systemFont(ofSize: 17.5 * RatioCoeff.width)
        label.textAlignment = .center
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14 * RatioCoeff.width)
        label.text = "2022"
        label.textAlignment = .center
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowRight"), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        return button
    }()
    
    @objc func nextMonth() {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowLeft"), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        return button
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = Theme.current.grayColor
        return view
    }()
    

    @objc func previousMonth() {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    let day1 = CalendarLabel(text: "Пн")
    let day2 = CalendarLabel(text: "Вт")
    let day3 = CalendarLabel(text: "Ср")
    let day4 = CalendarLabel(text: "Чт")
    let day5 = CalendarLabel(text: "Пт")
    let day6 = CalendarLabel(text: "Сб")
    let day7 = CalendarLabel(text: "Вс")
    
    lazy var weekDays = [day1, day2, day3, day4, day5, day6, day7]
    
    let stackView = UIStackView()
    
    var count1: Int = 0
    var count2: Int = 0
    
    private lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0

      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.isScrollEnabled = false
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
    }()
    
    var selectedDate = Date()
    var totalSquare = [String]()
    var dates = [Date]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedMonth = CalendarHelper().monthString(date: selectedDate)
        selectedYear = CalendarHelper().yearString(date: selectedDate)
        view.backgroundColor = .clear
        
        configure()
        configureCollectionView()
        setMonthView()
        self.touchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
    }
    
    @objc func viewPressed() {
        dismiss(animated: true)
    }
    
    let touchView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
        configureCollectionView()
        setMonthView()
    }

    
    func setMonthView() {
        totalSquare.removeAll()
        dates.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstDayOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        // last day of previous month
        let lastDateOfPrevious = CalendarHelper().LastDayOfPreviousMonth(date: firstDayOfMonth)
        var lastDayOfPrevious = CalendarHelper().daysOfMonth(date: lastDateOfPrevious)
        
        
        var count: Int = 1
        var previousCount = 0
        var nextMonthCount = 1
        var count3 = 0
        while(count <= 42) {
            if(count <= startingSpaces) {
                totalSquare.append("")
                dates.append(Date())

                previousCount += 1
            } else if count - startingSpaces > daysInMonth {
                totalSquare.append(String(nextMonthCount))
                dates.append(CalendarHelper().nextDay(date: firstDayOfMonth, next: daysInMonth + nextMonthCount - 1))
                nextMonthCount += 1
            } else {
                totalSquare.append(String(count - startingSpaces))
                dates.append(CalendarHelper().nextDay(date: firstDayOfMonth, next: count3))
                if CalendarHelper().daysOfMonth(date: selectedDate) == count - startingSpaces {              // ****************
                    selectedIndex = count - 1
                }
                count3 += 1
            }
            count += 1
        }
        
        count1 = previousCount
        count2 = nextMonthCount
        var count4 = 0
        
        while(previousCount > 0) {
            totalSquare[previousCount - 1] = String(lastDayOfPrevious)
            dates[previousCount - 1] = CalendarHelper().nextDay(date: firstDayOfMonth, next: -count4 - 1)
            lastDayOfPrevious -= 1
            previousCount -= 1
            count4 += 1
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
        yearLabel.text = CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 20
    }

    private func configure() {
        view.addSubview(calendarView)
        view.addSubview(touchView)
        calendarView.addSubview(monthLabel)
        calendarView.addSubview(yearLabel)
        calendarView.addSubview(rightButton)
        calendarView.addSubview(leftButton)
        calendarView.addSubview(collectionView)
        calendarView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.addSubview(topLine)
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually

        for i in 0...6 {
            stackView.addArrangedSubview(weekDays[i])
        }
        
        topLine.anchor(top: calendarView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 4))
        topLine.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 2),
            calendarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            
            touchView.topAnchor.constraint(equalTo: view.topAnchor),
            touchView.bottomAnchor.constraint(equalTo: calendarView.topAnchor),
            touchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            touchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 16),
            stackView.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 17 * RatioCoeff.height),
            
            collectionView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 21.6 * RatioCoeff.height),
            collectionView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor),
            
            monthLabel.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 36 * RatioCoeff.height),
            monthLabel.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor),
            monthLabel.heightAnchor.constraint(equalToConstant: 18 * RatioCoeff.height),
            monthLabel.widthAnchor.constraint(equalToConstant: 180),
            
            yearLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 5),
            yearLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 14.5 * RatioCoeff.height),
            yearLabel.widthAnchor.constraint(equalToConstant: 40),
            
            leftButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 16),
            leftButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 35 * RatioCoeff.height),
            leftButton.heightAnchor.constraint(equalToConstant: 30 * RatioCoeff.width),
            leftButton.widthAnchor.constraint(equalToConstant: 30 * RatioCoeff.width),
            
            rightButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -16),
            rightButton.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 35 * RatioCoeff.height),
            rightButton.heightAnchor.constraint(equalToConstant: 30 * RatioCoeff.width),
            rightButton.widthAnchor.constraint(equalToConstant: 30 * RatioCoeff.width),
        ])
        
    }
    
    @objc func doSomething() {
    }
}


extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.reuseID, for: indexPath) as! CalendarCollectionViewCell
        
        cell.set(text: totalSquare[indexPath.item], backgroundColor: UIColor.white)
        
        if indexPath.item < count1 || indexPath.item > 42 - count2 {
            cell.monthLabel.textColor = .systemGray
        } else {
            cell.monthLabel.textColor = .black
        }
        
        if indexPath.item == selectedIndex && selectedMonth == monthLabel.text && selectedYear == yearLabel.text {
            cell.monthLabel.textColor = .white
            cell.set(text: totalSquare[indexPath.item], backgroundColor: UIColor.systemOrange)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doSomething))
        cell.addGestureRecognizer(tap)

        tap.cancelsTouchesInView = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquare.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.item]
        selectedIndex = indexPath.item
        selectedMonth = CalendarHelper().monthString(date: selectedDate)
        selectedYear = CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
        delegate?.didTapCalendar(selectedDate: selectedDate)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / 7
    return CGSize(width: width, height: height)
  }
}

