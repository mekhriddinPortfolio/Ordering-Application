//
//  ProductTableViewCell.swift
//  Oq ot
//
//  Created by Mekhriddin on 12/07/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    lazy var myView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var productNameLabel = OrderHistoryLabel(fontSize: 15, weight: .regular, textColor: .black)
    lazy var productTypeLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var productCostLabel = OrderHistoryLabel(fontSize: 15, weight: .regular, textColor: .systemOrange)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        giveConstraints()
    }
    
    func setData(model: GoodToOrder) {
        productImageView.kf.setImage(with: URL(string: model.goodImagePath ?? ""))
        productNameLabel.text = model.goodName
        productTypeLabel.text = model.goodName
        productCostLabel.text = "\(model.goodSellingPrice.notNullString) \("sum".translate())"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func giveConstraints() {
        contentView.addSubview(myView)
        myView.addSubview(productImageView)
        myView.addSubview(productNameLabel)
        myView.addSubview(productTypeLabel)
        myView.addSubview(productCostLabel)
        
        myView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0))
        productImageView.anchor(top: nil, leading: myView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 60, height: 60))
        productImageView.centerYAnchor.constraint(equalTo: myView.centerYAnchor).isActive = true
        productNameLabel.anchor(top: myView.topAnchor, leading: productImageView.trailingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 17))
        productTypeLabel.anchor(top: productNameLabel.bottomAnchor, leading: productImageView.trailingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 15))
        productCostLabel.anchor(top: productTypeLabel.bottomAnchor, leading: productImageView.trailingAnchor, bottom: nil, trailing: myView.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 15, bottom: 0, right: 15), size: CGSize(width: 0, height: 17))
    }

}
