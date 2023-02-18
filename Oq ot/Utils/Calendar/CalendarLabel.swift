//
//  CustomLabel.swift
//  Calendar
//
//  Created by Mekhriddin on 08/07/22.
//

import UIKit

class CalendarLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        textColor = .systemGray
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 13)
        self.text = text
        textAlignment = .center
    }
    
    private func configure() {
        textColor = .systemGray
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 13)
        text = "Пн"
        textAlignment = .center
    }

}

