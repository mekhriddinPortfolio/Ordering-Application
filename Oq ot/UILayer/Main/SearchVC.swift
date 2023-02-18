//
//  SearchViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 16/07/22.
//

import UIKit

class SearchViewController: BaseViewController {
    
    let searchView = SearchView()
    let viewModel = MainScreenViewModel()
    var searchText = ""
    var page = 0
    let shadowView = UIView(frame: .zero)
    private var shapeLayer: CAShapeLayer?
    var data: DiscountedGoodsModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var isSearching = false
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "object")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var emptyUILabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(17, "emptyScreen".translate(), false, UIColor(hex: "#000000", alpha: 0.6), .center)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.addSubview(shadowView)
        searchView.delegate = self
        viewModel.didGetSearchedGoods = { [weak self] responce, error in
            guard let self = self else {return}
            if error == nil {
                if self.page == 0 {
                    self.data = responce
                    // UI change login here
                    if self.data?.data.count == 0 && self.isSearching {
                        print("Show")
                        self.emptyImageView.isHidden = false
                        self.emptyUILabel.isHidden = false
                        self.resultsLabel.text = ""
                        return
                    } else if self.data?.data.count != 0 && self.isSearching {
                        print("Hide")
                        self.emptyImageView.isHidden = true
                        self.emptyUILabel.isHidden = true
                    }
                    if self.data?.data.count == 0 {
                        return
                    }
                    // Main Logic here
                    let firstElement = self.data?.data[0].name ?? ""
                    if UD.lastSearchTexts.count < 10 {
                        if !UD.lastSearchTexts.contains(firstElement) {
                            UD.lastSearchTexts.append(firstElement)
                        } else {
                            UD.lastSearchTexts.remove(at: UD.lastSearchTexts.firstIndex(of: firstElement) ?? 0)
                            UD.lastSearchTexts.append(firstElement)
                        }
                    } else {
                        if !UD.lastSearchTexts.contains(firstElement) {
                            for count in 0 ... 8 {
                                UD.lastSearchTexts[count] = UD.lastSearchTexts[count + 1]
                            }
                            UD.lastSearchTexts[9] = firstElement
                        } else {
                            UD.lastSearchTexts.remove(at: UD.lastSearchTexts.firstIndex(of: firstElement) ?? 0)
                            UD.lastSearchTexts.append(firstElement)
                        }
                    }
                } else {
                    var alreadySavedData = self.data
                    if let anotherData = responce?.data {
                        alreadySavedData?.data.append(contentsOf: anotherData)
                    }
                    self.data = alreadySavedData
                }
                print(UD.lastSearchTexts)
            }
            self.resultsLabel.text = "resultsFromYourSearch".translate()
            self.emptyImageView.isHidden = true
            self.emptyUILabel.isHidden = true
        }
        hideNoInfoViewLogin()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        shadowView.frame = CGRect(x: 0, y: self.containerView.frame.minY - 3, width: SCREEN_SIZE.width, height: 14)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 1.0)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 20).cgPath
        shapeLayer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        shapeLayer.shadowOpacity = 1.0
        shapeLayer.shadowRadius = 4
        shapeLayer.borderWidth = 0.2
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shouldRasterize = true
        shapeLayer.rasterizationScale = UIScreen.main.scale
        if let oldShapeLayer = self.shapeLayer {
            shadowView.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            shadowView.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = twoLineTitleView(text: "Поиск".translate(), color: UIColor.white)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        self.viewModel.searchedGoods = nil
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = view.bounds
        l.colors = Theme.current.gradientLabelColors
        l.startPoint = CGPoint(x: 0, y: 1)
        l.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(l, at: 0)
        return l
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.whiteColor
        v.layer.cornerRadius = 20
        return v
    }()
    
    
    lazy var resultsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.attributedText = NSAttributedString.getAttrTextWith(15, "lastRequests".translate(), false, Theme.current.searchAndIconsColor, .left)
        return l
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.separatorStyle = .none
        t.backgroundColor = .white
        t.alwaysBounceVertical = false
        t.bounces = false
        t.keyboardDismissMode = .onDrag
        t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        t.showsVerticalScrollIndicator = false
        t.register(BasketCell.self, forCellReuseIdentifier: String.init(describing: BasketCell.self))
        t.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: String.init(describing: SearchHistoryTableViewCell.self))
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    @objc private func didTapView() {
        view.endEditing(true)
    }

    
    private func setupView() {
        view.backgroundColor = .clear
        view.insertSubview(topBackgroundImageView, at: 0)
        view.addSubview(containerView)
        containerView.addSubview(resultsLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(searchView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyUILabel)
        
        self.topBackgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 300))
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 80 * RatioCoeff.height, left: 0, bottom: 0, right: 0))
        searchView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        resultsLabel.anchor(top: searchView.bottomAnchor, leading: searchView.leadingAnchor, bottom: nil, trailing: searchView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 17))
        tableView.anchor(top: resultsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: containerView.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        emptyImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 192 * RatioCoeff.height, height: 182 * RatioCoeff.height))
        emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyUILabel.anchor(top: emptyImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 42, left: 67, bottom: 0, right: 67), size: CGSize(width: 0, height: 40))
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, BasketCellProtocol, SearchViewProtocol{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: BasketCell.self), for: indexPath) as! BasketCell
            cell.selectionStyle = .none
            cell.infoView.isUserInteractionEnabled = true
            cell.infoView.layer.cornerRadius = 10
            cell.delegate = self
            if let data = data {
                cell.setData(model: data.data[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: SearchHistoryTableViewCell.self), for: indexPath) as! SearchHistoryTableViewCell
            let searchData: [String] = UD.lastSearchTexts.reversed()
            cell.setData(productName: searchData[indexPath.row], isLast: indexPath.row == 9 ? false : true)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSearching ? 90 : 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? data?.data.count ?? 0 : UD.lastSearchTexts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        if resultsLabel.text == "lastRequests".translate() {
            let searchData: [String] = UD.lastSearchTexts.reversed()
            searchView.textField.text = ""
            searchView.textField.insertText(searchData[indexPath.row].replacingOccurrences(of: " ", with: ""))
        }
           
       }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.tableView else {return}
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            self.page += 1
            viewModel.searchGoods(queryString: searchText, page: self.page)
        }
    }
    
    func reloadCollection() {
      let newData = data
        self.data = newData
    }
    
    func editingDidEnd(text: String) {
        if text.count > 2 {
            isSearching = true
            searchText = text
            self.page = 0
            viewModel.searchGoods(queryString: text, page: 0)
        } else {
            isSearching = false
            hideNoInfoViewLogin()
        }
    }

    func hideNoInfoViewLogin() {
        if UD.lastSearchTexts.count == 0 {
            emptyImageView.isHidden = false
            emptyUILabel.isHidden = false
            resultsLabel.text = ""
            tableView.reloadData()
        } else {
            resultsLabel.text = "lastRequests".translate()
            tableView.reloadData()
            emptyImageView.isHidden = true
            emptyUILabel.isHidden = true
        }
    }
    
}





