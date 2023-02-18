//
//  CreditCardTypeViewController.swift
//  Oq ot
//
//  Created by AvazbekOS on 04/08/22.
//

import UIKit

protocol CreditCardTypeDelegate: AnyObject {
    func creditCardTypeChosen()
}

class CreditCardTypeViewController: BaseViewController {

    weak var delegate: CreditCardTypeDelegate?
    
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
    
    lazy var creditcardTypeLabel: UILabel = {
        let l = UILabel()
        l.attributedText = NSAttributedString.getAttrTextWith(17, "cardPayment".translate(), false, UIColor(hex: "#7A7A7A"), .center)
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
        view.addSubview(creditcardTypeLabel)
        view.addSubview(separatorLine)

        view.addSubview(collectionView)
       
        separatorView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 49, height: 5))
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        creditcardTypeLabel.anchor(top: separatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 20))
        separatorLine.anchor(top: creditcardTypeLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 1))
        
        collectionView.anchor(top: separatorLine.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: (56 * 4) + (3 * 5)))
        
    }
}

extension CreditCardTypeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PaymentTypeCell.self), for: indexPath) as! PaymentTypeCell
        
        switch indexPath.row {
        case 0:
            print("first")
            cell.setItem(data: PaymentTypeModel(text: "payCard".translate(), image: "credit-cardWhite"))
            cell.cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(creditcardButtonTapped)))
        case 1:
            print("second")
            cell.setItem(data: PaymentTypeModel(text: "Click", image: "click"))
            cell.cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickButtonTapped)))
        case 2:
            print("third")
            cell.setItem(data: PaymentTypeModel(text: "Payme", image: "payme"))
            cell.cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymeButtonTapped)))
        case 3:
            print("fouth")
            cell.setItem(data: PaymentTypeModel(text: "Apelsin", image: "apelsin"))
            cell.cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(apelsinButtonTapped)))
        default:
            break
        }
        return cell
    }
    
    @objc func creditcardButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.creditCardTypeChosen()
        }
    }
    
    @objc func clickButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.creditCardTypeChosen()
        }
    }
    
    @objc func paymeButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.creditCardTypeChosen()
        }
    }
    
    @objc func apelsinButtonTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.creditCardTypeChosen()
        }
    }
}
