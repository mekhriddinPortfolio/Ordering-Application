//
//  CashOrTerminalViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 04/08/22.
//

import UIKit

protocol CashOrTerminalDelegate: AnyObject {
    func cashOrTerminalChosen(name: String)
}

class CashOrTerminalViewController: BaseViewController {

    weak var delegate: CashOrTerminalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.separatorLineBackColor
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    lazy var cashOrTerminalLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "cash/terminal".translate(), false, UIColor(hex: "#7A7A7A"), .center)
        return l
    }()
    
    let separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = Theme.current.blackColor.withAlphaComponent(0.08) 
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 1
        return v
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.decelerationRate = .normal
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.register(PaymentTypeCell.self, forCellWithReuseIdentifier: String(describing: PaymentTypeCell.self))
        collection.alwaysBounceVertical = true
        
        return collection
    }()
    
    private func setupView() {
        view.addSubview(separatorView)
        view.addSubview(cashOrTerminalLabel)
        view.addSubview(separatorLine)
        view.addSubview(collectionView)
       
        separatorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 49, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cashOrTerminalLabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        separatorLine.anchor(top: cashOrTerminalLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        collectionView.anchor(top: separatorLine.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: (56*2) + 5))
    }
}

extension CashOrTerminalViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PaymentTypeCell.self), for: indexPath) as! PaymentTypeCell
        
        switch indexPath.row {
        case 0:
            print("first")
            cell.setItem(data: PaymentTypeModel(text: "cash".translate(), image: "cashWhite"))
            cell.cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cashButtonTapped)))
        case 1:
            print("second")
            cell.setItem(data: PaymentTypeModel(text: "terminal".translate(), image: "terminal"))
            cell.cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(terminalButtonTapped)))
        default:
            break
        }
        return cell
    }
    
    @objc func cashButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.cashOrTerminalChosen(name: "Оплата наличными")
        }
    }
    
    @objc func terminalButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.cashOrTerminalChosen(name: "Оплата наличными")
        }
    }
}
