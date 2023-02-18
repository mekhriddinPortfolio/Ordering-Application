//
//  CalendarCollectionViewCell.swift
//  Calendar
//
//  Created by Mekhriddin on 08/07/22.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "cell"
    
    var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    func set(text: String, backgroundColor: UIColor){
        monthLabel.text = text
        selectionBackgroundView.backgroundColor = backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        contentView.addSubview(selectionBackgroundView)
        selectionBackgroundView.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([

            selectionBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: 30),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor),
            
            monthLabel.topAnchor.constraint(equalTo: selectionBackgroundView.topAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: selectionBackgroundView.trailingAnchor),
            monthLabel.bottomAnchor.constraint(equalTo: selectionBackgroundView.bottomAnchor),
            
        ])
    }
}



