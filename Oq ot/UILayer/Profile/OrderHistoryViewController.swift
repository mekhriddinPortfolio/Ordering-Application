//
//  OrderHistoryViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 11/07/22.
//

import UIKit

struct OrderHistory:Codable {
    let pageIndex, pageCount: Int?
    var data: [Datum]
    let totalCount: Int?
}

// MARK: - Datum
struct Datum:Codable {
    let courierID: String?
    let sellingPrice: Int?
    let id: String?
    let toLongitude: Double?
    let createdAt: String?
    let toLatitude: Double?
    let clientID, finishedAt: String?
    let isPickup: Bool?
    let status: Int?
    let goodToOrders: [GoodToOrder]
}

// MARK: - GoodToOrder
struct GoodToOrder:Codable {
    let id: String?
    let goodDiscount: Int?
    let goodName, orderID: String?
    let goodImagePath: String?
    let count: Int?
    let goodID: String?
    let goodSellingPrice: Int?
}



class OrderHistoryViewController: BaseViewController {
    
    let viewModel = ProfileViewModel()
    var lastOrders: OrderHistory? {
        didSet {
            if let lastOrders = lastOrders {
                if (lastOrders.data.isEmpty) {
                    emptyCaseView.isHidden = false
                } else {
                    emptyCaseView.isHidden = true
                }
            }
            self.tableView.reloadData()
        }
    }
    var page = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = twoLineTitleView(text: "yourOrders".translate(), color: UIColor.white)
        self.tabBarController?.tabBar.isHidden = false
        
        viewModel.getOrderHistory(pageIndex: 0, pageSize: 10)
        viewModel.didGetOrderHistory = { [weak self] lastOrders, error in
            guard let self = self else {return}
            if error == nil {
                if self.page == 0 {
                    self.lastOrders = lastOrders
                } else {
                    var alreadySavedData = self.lastOrders
                    if let anotherData = lastOrders {
                        alreadySavedData?.data.append(contentsOf: anotherData.data)
                    }
                    self.lastOrders = alreadySavedData
                }
            }
        }
        
        emptyCaseView.actionButton.addTarget(self, action: #selector(goForMainTapped), for: .touchUpInside)
        setEmptyCondition()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.alpha = 0.15
        return imageView
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = view.bounds
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(l, at: 0)
        return l
    }()
    
    let emptyCaseView = EmptyReusableView(imageName: "historyEmptyImg", text: "История ваших заказов пуста", desc: "Список ваших заказов пуст, информация об оформленном заказе будет появляться тут", buttonTitle: "Продолжить покупки", height: 240*RatioCoeff.height, leftRightPadding: 40*RatioCoeff.width)
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteColor
        v.layer.cornerRadius = 20
        return v
    }()
    
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorStyle = .none
        t.backgroundColor = .white
        t.showsVerticalScrollIndicator = false
        t.delegate = self
        t.dataSource = self
        t.register(OrderHistoryCell.self, forCellReuseIdentifier: String.init(describing: OrderHistoryCell.self))
        return t
    }()
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("XXXXXXX")
            guard scrollView == self.tableView else {return}
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                self.page += 1
                viewModel.getOrderHistory(pageIndex: page, pageSize: 10)
            }
        }

    
    private func setupView() {
        view.insertSubview(backgroundImageView, at: 0)
        view.insertSubview(containerView, aboveSubview: backgroundImageView)
        
        containerView.addSubview(tableView)
        containerView.insertSubview(emptyCaseView, aboveSubview: tableView)
        
        let screenSize = UIScreen.main.bounds.size
        backgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: (screenSize.width - 50), height: (screenSize.width - 50) * 2 / 3))
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        
        tableView.anchor(top: containerView.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 10, right: 16))
        emptyCaseView.anchor(top: tableView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
    }
    
    @objc func goForMainTapped() {
        defer {
            self.back(with: .pop)
        }
        self.tabBarController?.selectedIndex = 1
        if let tabbar = self.tabBarController as? MainTabbarController {
            tabbar.profileImage.image = tabbar.profileImage.image?.withRenderingMode(.alwaysTemplate)
            tabbar.profileImage.tintColor = .lightGray
            tabbar.imageV.image = tabbar.imageV.image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func setEmptyCondition() {
        if lastOrders?.data == nil || lastOrders?.data.isEmpty ?? true {
            emptyCaseView.isHidden = false
        } else {
            emptyCaseView.isHidden = true
        }
    }
    
    var selectedIndex: Int = -1
    var isCollapse: Bool = false
    let butonsHeight: CGFloat = 127
    var numberOfProducts = 0
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: OrderHistoryCell.self), for: indexPath) as! OrderHistoryCell
        cell.set(model: (lastOrders?.data[indexPath.row])!)
        cell.layer.cornerRadius = 10
        cell.selectionStyle = .none
        cell.openMainButtonTapped = { [weak self] in
            guard let self = self else {return}
            self.tabBarController?.selectedIndex = 1
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (lastOrders?.data[indexPath.row].goodToOrders.count ?? 0) > 3 {
            numberOfProducts = 3
        } else {
            numberOfProducts = lastOrders?.data[indexPath.row].goodToOrders.count ?? 0
        }

        if selectedIndex == indexPath.row && isCollapse == true { return 230 + 90 + butonsHeight + CGFloat(numberOfProducts) * 80}
        
        return 230
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastOrders?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            if isCollapse == false {
                isCollapse = true
            } else {
                isCollapse = false
            }
        } else {
            isCollapse = true
        }
        
        selectedIndex = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

