//
//  ProfileViewController.swift
//  Oq ot
//
//  Created by Mekhriddin on 07/07/22.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let tableView = UITableView()
    let viewModel = ProfileViewModel()
    var model: ProfileInfoModel?
    
    var menus = [[Profile(image: "credit-card", name: "plasticCard".translate()), Profile(image: "location", name: "myLocation".translate()), Profile(image: "love", name: "favourites".translate()), Profile(image: "badge", name: "vaucherAndPromo".translate())], [Profile(image: "settings", name: "settings".translate()), Profile(image: "suitcase", name: "vacancy".translate()), Profile(image: "support", name: "techSupport1".translate()), Profile(image: "info", name: "aboutService".translate())]]
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.alpha = 0.15
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileAvatar")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 44 * RatioCoeff.height
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(17, " ", false, Theme.current.grayLabelColor7, .center)
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(15, " ", false, Theme.current.grayLabelColor4, .center)
        return label
    }()
    
    lazy var ordersView: GradiendView = {
        let  view = GradiendView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ordersTapped)))
        view.gradientLayer.cornerRadius = 24 * RatioCoeff.height
        return view
    }()
    
    lazy var ordersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shopping-bag 1 (2)")
        return imageView
    }()
    
    @objc func ordersTapped() {
        let vc = OrderHistoryViewController()
        self.perform(transition: vc)
        print("Orders Tapped")
    }
    
    let ordersLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "orders".translate(), false, Theme.current.grayLabelColor6, .center)
        return label
    }()
    
    lazy var chatView: GradiendView = {
        let  view = GradiendView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatTapped)))
        view.gradientLayer.cornerRadius = 24 * RatioCoeff.height
        return view
    }()
    
    lazy var chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chat 1")
        return imageView
    }()
    
    @objc func chatTapped() {
        self.perform(transition: ChatViewController())
    }
    
    let chatLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.getAttrTextWith(14, "chat".translate(), false, Theme.current.grayLabelColor6, .center)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.white.cgColor
        viewModel.didGetUserProfile = { [weak self] profileInfo, error in
            guard let self = self else {return}
            if error == nil {
                self.nameLabel.text = "\(profileInfo?.firstName ?? "") \(profileInfo?.lastName ?? "")"
                self.phoneLabel.text = profileInfo?.login
                
                if let profileImg = profileInfo?.avatarPhotoPath {
                self.profileImageView.kf.setImage(with: URL(string: "\(baseUrl):5055/api/1.0/file/download/\(profileImg)"))
                }
                self.model = profileInfo
                print(profileInfo)
            } else {
                print("ERROR: \(error)")
            }
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+50*RatioCoeff.height)
        setupNavbar()
        configureTableView()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserProfile()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        tableView.rowHeight = 55
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseID)
    }
    
    private func configure() {
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(phoneLabel)
        scrollView.addSubview(tableView)
        scrollView.addSubview(ordersView)
        scrollView.addSubview(chatView)
        scrollView.addSubview(ordersLabel)
        scrollView.addSubview(chatLabel)
        
        ordersView.addSubview(ordersImageView)
        chatView.addSubview(chatImageView)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        
        let screenSize = UIScreen.main.bounds.size
        backgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: screenSize.width, height: screenSize.width * 2 / 3))
        
        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        profileImageView.anchor(top: scrollView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 48 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 88 * RatioCoeff.height, height: 88 * RatioCoeff.height))
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 17 * RatioCoeff.height))
        phoneLabel.anchor(top: nameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 16 * RatioCoeff.height))
        
        ordersView.anchor(top: phoneLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 48 * RatioCoeff.height, height: 48 * RatioCoeff.height))
        ordersView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(24 * RatioCoeff.height + 7.5)).isActive = true
        ordersImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 24, height: 24))
        ordersImageView.centerXAnchor.constraint(equalTo: ordersView.centerXAnchor).isActive = true
        ordersImageView.centerYAnchor.constraint(equalTo: ordersView.centerYAnchor).isActive = true
        ordersLabel.anchor(top: ordersView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 75, height: 16))
        ordersLabel.centerXAnchor.constraint(equalTo: ordersView.centerXAnchor).isActive = true
        
        chatView.anchor(top: phoneLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 48 * RatioCoeff.height, height: 48 * RatioCoeff.height))
        chatView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 24 * RatioCoeff.height + 7.5).isActive = true
        chatImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 24, height: 24))
        chatImageView.centerXAnchor.constraint(equalTo: chatView.centerXAnchor).isActive = true
        chatImageView.centerYAnchor.constraint(equalTo: chatView.centerYAnchor).isActive = true
        chatLabel.anchor(top: chatView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 50, height: 16))
        chatLabel.centerXAnchor.constraint(equalTo: chatView.centerXAnchor).isActive = true
        tableView.anchor(top: chatLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 11 * RatioCoeff.height, left: 15, bottom: 50, right: 15))
    }
    
    private func setupNavbar() {
        let newImage = UIImage.imageWithImage(image: UIImage.init(named: "logOut")!,
                                              scaledToSize: CGSize(width: 42, height: 42))
        let logoutButton = UIBarButtonItem(image: newImage.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapLogout(_:)))
        navigationItem.rightBarButtonItem = logoutButton
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapLogout (_ sender: UIButton) {
        showAlertMessage(firstText: "Вы уверены?", secondText: "Вы действительно хотите выйти со своего аккаунта?", successButtonText: "Выйти") {
            self.dismiss(animated: true) {
                print("TOKENS INFO: \(UD.tokenType)")
                print(UD.token)
                print(UD.refreshToken)
                Utils.delay(seconds: 0) {
                    UD.tokenType = nil
                    UD.token = nil
                    UD.expiresAt = nil
                    UD.refreshToken = nil
                    AppDelegate.shared?.setRoot(viewController: MainTabbarController(isRegistered: false))
                    print("TOKENS INFO AFTER: \(UD.tokenType)")
                    print(UD.token)
                    print(UD.refreshToken)
                }
            }
        } cancel: {
            self.dismiss(animated: true)
        }
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 * RatioCoeff.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseID) as! ProfileTableViewCell
        let profile = menus[indexPath.section][indexPath.row]
        cell.set(profile: profile)


        cell.selectionStyle = .none
        cell.backgroundColor = Theme.current.grayCellColor

        if indexPath.row == 0 { // first element
           cell.layer.masksToBounds = true
           cell.layer.cornerRadius = 10
           cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       } else if indexPath.row == menus[indexPath.section].count - 1 { // last element
           cell.layer.masksToBounds = true
           cell.layer.cornerRadius = 10
           cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        if indexPath.row == menus[indexPath.section].count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let vc = UserCardsController()
                self.perform(transition: vc)
            case 1:
                let vc = ProfileAddressController()
                self.perform(transition: vc)
            case 2:
                let vc = LikedGoodsViewController()
                vc.goodsModel = CoreDataSyncManager.shared.fetchLikedGoods()
                self.perform(transition: vc)
            case 3:
                let vc = NotCompletedFuncViewController()
                self.perform(transition: vc)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                let vc = SettingsViewController()
                vc.model = model
                self.perform(transition: vc)
            case 1:
                Utils.open(url: "https://windlace.uz")
            case 2:
                Utils.callNumber(phoneNumber: "+998909311978")
            case 3:
                Utils.open(url: "https://windlace.uz")
            default:
                break
            }
        }
    }
}

struct Profile {
    var image: String
    var name: String
}
