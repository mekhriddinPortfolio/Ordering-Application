//
//  InitialProfileViewController.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 01/08/22.
//

import UIKit

class InitialProfileViewController: BaseViewController {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.alpha = 0.15
        return imageView
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "illustration")
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
    
    let comeInLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(22, "comeIn".translate(), false, Theme.current.blackColor, .center)
        return l
    }()
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(15, "comeIn".translate(), false, Theme.current.grayLabelColor5, .center)
        return l
    }()
    
    lazy var comeInButton: BaseButton = {
        let btn = BaseButton(title: "comeIn".translate(), size: 15)
        btn.addTarget(self, action: #selector(comeInTapped), for: .touchUpInside)
        return btn
    }()
    
    var menus = [Profile(image: "settings", name: "settings".translate()), Profile(image: "suitcase", name: "vacancy".translate()), Profile(image: "info", name: "aboutService".translate())]
    
    let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+25*RatioCoeff.height)
        configureTableView()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        tableView.rowHeight = 55
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Theme.current.grayCellColor
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseID)
    }
    
    private func configure() {
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(mainImageView)
        scrollView.addSubview(comeInLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(comeInButton)
        scrollView.addSubview(tableView)
        
        
        let screenSize = UIScreen.main.bounds.size
        backgroundImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: screenSize.width, height: screenSize.width * 2 / 3))
        
        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        mainImageView.anchor(top: scrollView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 53 * RatioCoeff.height, left: 0, bottom: 0, right: 0), size: CGSize(width: 185 * RatioCoeff.height, height: 181 * RatioCoeff.height))
        mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        comeInLabel.anchor(top: mainImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 22 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 22 * RatioCoeff.width))
        descriptionLabel.anchor(top: comeInLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 8 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 35 * RatioCoeff.width))
        comeInButton.anchor(top: descriptionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50 * RatioCoeff.width))
        tableView.anchor(top: comeInButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 22 * RatioCoeff.height, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 55 * CGFloat(menus.count)))
        
        descriptionLabel.attributedText = NSAttributedString.getAttrTextWith(13 * RatioCoeff.width, "comeInInfo".translate(), false, .black, .center)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.alpha = 0.5
    }
    
    @objc func comeInTapped() {
        self.perform(transition: LoginPhoneNumController())
    }
}


extension InitialProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseID) as! ProfileTableViewCell
        let profile = menus[indexPath.row]
        cell.set(profile: profile)
        cell.selectionStyle = .none
        if indexPath.row == menus.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.perform(transition: SettingsViewController())
        case 1:
            print("vacancy")
            Utils.open(url: "https://windlace.uz")
        case 2:
            print("about service")
            Utils.open(url: "https://windlace.uz")
        default:
            break
        }
    }

}
