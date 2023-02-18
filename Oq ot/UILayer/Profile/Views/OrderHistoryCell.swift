//
//  OrderHistoryCell.swift
//  Oq ot
//
//  Created by Mekhriddin on 11/07/22.
//

import UIKit

class OrderHistoryCell: UITableViewCell {
    
    var openMainButtonTapped: (() -> Void)?
    lazy var orderNumLabel = OrderHistoryLabel(fontSize: 14 * RatioCoeff.width, weight: .regular, textColor: .black)
    lazy var paymentTypeLabel2 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var paymentTypeLabel1 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var deliveryTypeLabel1 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var deliveryTypeLabel2 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var registerDateLabel1 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var registerDateLabel2 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var sumLabel1 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var sumLabel2 = OrderHistoryLabel(fontSize: 17, weight: .regular, textColor: .black)
    lazy var productsLabel1 = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var productsLabel2 = OrderHistoryLabel(fontSize: 14, weight: .regular, textColor: .black)
    lazy var promoCodeLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var promoCodeSumLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var goodCountLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var goodSumLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var deliveryLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .systemGray)
    lazy var deliverySumLabel = OrderHistoryLabel(fontSize: 13, weight: .regular, textColor: .black)
    lazy var statusButton = BaseButton(title: "", size: 14)
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.grayCellColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var separatorLine1: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var separatorLine2: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var separatorLine3: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.separatorViewGrayColor
        return view
    }()
    
    lazy var skipButton: UIButton = {
        let b = UIButton()
        b.setTitle("backToOrders".translate(), for: .normal)
        b.layer.cornerRadius = 8
        b.setTitleColor(UIColor.black, for: .normal)
        b.backgroundColor = .white
        b.layer.borderWidth = 1
        b.titleLabel?.font = UIFont.systemFont(ofSize: 15 * RatioCoeff.width)
        b.layer.borderColor = Theme.current.borderOrangeColor.cgColor
        return b
    }()
    
    let saveButton = BaseButton(title: "", size: 14)
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorStyle = .none
        t.backgroundColor = .white
        return t
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureData()
        //setupView()
        clipsToBounds = true
        
        saveButton.setTitle("technicalSupport".translate(), for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        Utils.callNumber(phoneNumber: "+998909311978")
    }
    
    @objc func skipButtonTapped() {
        openMainButtonTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
var model: Datum?
    func set(model: Datum) {
        self.model = model
        orderNumLabel.text = "\("OrderNum".translate())\(model.id ?? "")"
        paymentTypeLabel2.text = model.id
        deliveryTypeLabel2.text = model.isPickup == true ? "pickup".translate() : "delivery".translate()
        registerDateLabel2.text = getTimeFromString(date: model.createdAt ?? "")
        
        sumLabel2.text = "\(model.sellingPrice.notNullString) \("sum".translate())"
        var products: String = ""
        for product in model.goodToOrders {
            if let name = product.goodName {
                products += "\(name), "
            }
        }
        
        goodSumLabel.text = model.sellingPrice.notNullString
        
        productsLabel2.text = products
        goodCountLabel.text = goodCountLabel.text!.replacingOccurrences(of: "#", with: "\(model.goodToOrders.count)")
        
        switch model.status {
        case 0:
            statusButton.setTitle("Created", for: .normal)
        case 1:
            statusButton.setTitle("Collecting", for: .normal)
        case 2:
            statusButton.setTitle("Delivering", for: .normal)
        case 3:
            statusButton.setTitle("Success", for: .normal)
        case 4:
            statusButton.setTitle("Canceled by User", for: .normal)
        case 5:
            statusButton.setTitle("Canceled by Admin", for: .normal)
        default:
            statusButton.setTitle("Not Available", for: .normal)
        }
        switch model.status {
        case 0, 1, 2, 3:
            statusButton.color1 = Theme.current.greenColor
            statusButton.color2 = Theme.current.greenColor
        case 4, 5:
            statusButton.color1 = Theme.current.redColor
            statusButton.color2 = Theme.current.redColor
        default:
            print("Not available")
        }

        cellCount1 = model.goodToOrders.count
        if cellCount1 > 3 {
            cellCount2 = cellCount1
            cellCount1 = 3
        } else {
            cellCount2 = cellCount1
        }
        tableView.reloadData()
        setupView()
    }
    
    func getTimeFromString(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        let date: Date? = dateFormatterGet.date(from: date)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date!)
        let minutes = calendar.component(.minute, from: date!)
        let minutesString = minutes <= 9 ? "0\(minutes)" : "\(minutes)"
        let hourString = hour <= 9 ? "0\(hour)" : "\(hour)"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let myStringDate = formatter.string(from: date!)
        return "\(myStringDate) \("at".translate()) \(hourString):\(minutesString)"
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 2.5, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 230 + cellCount1 * 80 + 90))
        containerView.addSubview(statusButton)
        statusButton.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 20), size: CGSize(width: 132 * RatioCoeff.width, height: 35))
        containerView.addSubview(orderNumLabel)
        orderNumLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: statusButton.leadingAnchor, padding: UIEdgeInsets(top: 23, left: 20, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        containerView.addSubview(separatorLine1)
        separatorLine1.anchor(top: statusButton.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))
        containerView.addSubview(productsLabel1)
        productsLabel1.anchor(top: orderNumLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 0), size: CGSize(width: (productsLabel1.text?.widthOfString(usingFont: productsLabel1.font) ?? 90) + 1, height: 20))
        containerView.addSubview(productsLabel2)
        productsLabel2.anchor(top: nil, leading: productsLabel1.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        productsLabel2.centerYAnchor.constraint(equalTo: productsLabel1.centerYAnchor).isActive = true
        containerView.addSubview(paymentTypeLabel1)
        paymentTypeLabel1.anchor(top: productsLabel1.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0), size: CGSize(width: (paymentTypeLabel1.text?.widthOfString(usingFont: paymentTypeLabel1.font) ?? 90) + 1, height: 15))
        containerView.addSubview(paymentTypeLabel2)
        paymentTypeLabel2.anchor(top: nil, leading: paymentTypeLabel1.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 15))
        paymentTypeLabel2.centerYAnchor.constraint(equalTo: paymentTypeLabel1.centerYAnchor).isActive = true
        containerView.addSubview(deliveryTypeLabel1)
        deliveryTypeLabel1.anchor(top: paymentTypeLabel1.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0), size: CGSize(width: deliveryTypeLabel1.text?.widthOfString(usingFont: deliveryTypeLabel1.font) ?? 90, height: 15))
        containerView.addSubview(deliveryTypeLabel2)
        deliveryTypeLabel2.anchor(top: nil, leading: deliveryTypeLabel1.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 15))
        deliveryTypeLabel2.centerYAnchor.constraint(equalTo: deliveryTypeLabel1.centerYAnchor).isActive = true
        
        containerView.addSubview(separatorLine2)
        separatorLine2.anchor(top: deliveryTypeLabel1.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))
        containerView.addSubview(registerDateLabel1)
        registerDateLabel1.anchor(top: deliveryTypeLabel1.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: registerDateLabel1.text?.widthOfString(usingFont: registerDateLabel1.font) ?? 90, height: 15))
        containerView.addSubview(registerDateLabel2)
        registerDateLabel2.anchor(top: nil, leading: registerDateLabel1.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 15))
        registerDateLabel2.centerYAnchor.constraint(equalTo: registerDateLabel1.centerYAnchor).isActive = true
        containerView.addSubview(sumLabel1)
        sumLabel1.anchor(top: registerDateLabel1.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 14, left: 20, bottom: 0, right: 0), size: CGSize(width: sumLabel1.text?.widthOfString(usingFont: sumLabel1.font) ?? 90, height: 15))
        containerView.addSubview(sumLabel2)
        sumLabel2.anchor(top: nil, leading: sumLabel1.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 20))
        sumLabel2.centerYAnchor.constraint(equalTo: sumLabel1.centerYAnchor).isActive = true
        containerView.addSubview(separatorLine3)
        separatorLine3.anchor(top: sumLabel1.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 1))
        containerView.addSubview(promoCodeLabel)
        promoCodeLabel.anchor(top: separatorLine3.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 0), size: CGSize(width: promoCodeLabel.text?.widthOfString(usingFont: promoCodeLabel.font) ?? 90, height: 15))
        containerView.addSubview(promoCodeSumLabel)
        promoCodeSumLabel.anchor(top: nil, leading: promoCodeLabel.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 15))
        promoCodeSumLabel.centerYAnchor.constraint(equalTo: promoCodeLabel.centerYAnchor).isActive = true
        containerView.addSubview(goodCountLabel)
        goodCountLabel.anchor(top: promoCodeLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0), size: CGSize(width: (goodCountLabel.text?.widthOfString(usingFont: goodCountLabel.font) ?? 90) + 1, height: 15))
        containerView.addSubview(goodSumLabel)
        goodSumLabel.anchor(top: nil, leading: goodCountLabel.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 15))
        goodSumLabel.centerYAnchor.constraint(equalTo: goodCountLabel.centerYAnchor).isActive = true
        containerView.addSubview(deliveryLabel)
        deliveryLabel.anchor(top: goodCountLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0), size: CGSize(width: deliveryLabel.text?.widthOfString(usingFont: deliveryLabel.font) ?? 90, height: 15))
        containerView.addSubview(deliverySumLabel)
        deliverySumLabel.anchor(top: nil, leading: deliveryLabel.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20), size: CGSize(width: 0, height: 15))
        deliverySumLabel.centerYAnchor.constraint(equalTo: deliveryLabel.centerYAnchor).isActive = true
        containerView.addSubview(tableView)
        tableView.anchor(top: deliveryLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 5, bottom: 0, right: 5), size: CGSize(width: 0, height: cellCount1 * 80))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Theme.current.grayCellColor
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String.init(describing: ProductTableViewCell.self))
        contentView.addSubview(saveButton)
        contentView.addSubview(skipButton)
        saveButton.anchor(top: skipButton.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
        skipButton.anchor(top: containerView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 56))
    }
    
    private func configureData() {
        paymentTypeLabel1.text = "paymentType".translate()
        deliveryTypeLabel1.text = "deliveryType".translate()
        registerDateLabel1.text = "dateIssued".translate()
        sumLabel1.text = "total".translate()
        productsLabel1.text = "good".translate()
        
        promoCodeLabel.text = "vaucherPromoKod".translate()
        promoCodeSumLabel.text = "- -"
        goodCountLabel.text = "# \("product".translate()):"
        goodSumLabel.text = "10 000 \("sum".translate())"
        deliveryLabel.text = "\("delivery".translate()): "
        deliverySumLabel.text = "- -"
    }
    
    var cellCount1 = 0
    var cellCount2 = 0
}


class OrderHistoryLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor){
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textColor = textColor
        configure()
    }
    
    private func configure(){
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .left
    }
}




extension OrderHistoryCell: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        if let items = model?.goodToOrders {
            cell.setData(model: items[indexPath.row])
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount2
    }

}
