//
//  MostUsedProductsView.swift
//  Oq ot
//
//  Created by AvazbekOS on 17/07/22.
//

import UIKit

class MostUsedProductsView: UIView {
    
    var categoryModel: CategoryModel? {
        didSet {
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
        tableView.register(MostUsedViewCell.self, forCellReuseIdentifier: String.init(describing: MostUsedViewCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var resultsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.text = "mostOftenSearched".translate()
        l.textAlignment = .left
        l.textColor = UIColor(hex: "#7A7A7A", alpha: 0.7)
        l.font = UIFont.systemFont(ofSize: 15)
        return l
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.backgroundColor = .white
        t.alwaysBounceVertical = false
        t.bounces = false
        t.contentInset = UIEdgeInsets.zero
        t.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        t.showsVerticalScrollIndicator = false
        t.backgroundColor = .white
        
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    private func setupView() {
        addSubview(resultsLabel)
        addSubview(tableView)
        resultsLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 17))
        tableView.anchor(top: resultsLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }

}

extension MostUsedProductsView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryModel?.categories.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * RatioCoeff.height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: MostUsedViewCell.self), for: indexPath) as! MostUsedViewCell
            cell.selectionStyle = .none
            if let data = categoryModel?.categories[indexPath.row]{
            cell.setData(data: data)
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            cell.accessoryType = .disclosureIndicator
            return cell
    }
    
}
